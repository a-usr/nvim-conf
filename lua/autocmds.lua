local UserAutoCmd = function(opts)
  vim.api.nvim_create_autocmd("User", opts)
end

local cmd = vim.api.nvim_create_autocmd

local function esc(x)
  return (
    x:gsub("%%", "%%%%")
      :gsub("^%^", "%%^")
      :gsub("%$$", "%%$")
      :gsub("%(", "%%(")
      :gsub("%)", "%%)")
      :gsub("%.", "%%.")
      :gsub("%[", "%%[")
      :gsub("%]", "%%]")
      :gsub("%*", "%%*")
      :gsub("%+", "%%+")
      :gsub("%-", "%%-")
      :gsub("%?", "%%?")
  )
end

UserAutoCmd {
  pattern = "PersistedStart",
  callback = function()
    vim.t.persisting = true
  end,
}

cmd("TabLeave", {
  callback = function()
    if vim.t.persisting then
      require("persisted").save()
    end
  end,
})

UserAutoCmd {
  pattern = "PersistedLoadPre",
  callback = function()
    for _, buffer in pairs(vim.t.bufs or {}) do
      vim.schedule(function()
        vim.cmd("silent! bd " .. tostring(buffer))
      end)
    end
  end,
}

UserAutoCmd {
  pattern = "PersistedLoadPost",
  callback = function()
    vim.t.persisted_loaded_session = vim.g.persisted_loaded_session
    vim.t.persisting_session = vim.g.persisting_session
    vim.t.persisting = vim.g.persisting
  end,
}

UserAutoCmd {
  pattern = "PersistedSavePre",
  callback = function()
    vim.g.persisting = vim.t.persisting
    vim.g.persisting_session = vim.t.persisting_session or vim.g.persisting_session
    vim.g.persisted_loaded_session = vim.t.persisted_loaded_session or vim.g.persisted_loaded_session
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].filetype == "NvimTree" or vim.bo[buf].filetype == "neo-tree" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
}

UserAutoCmd {
  pattern = "PersistedSavePost",
  callback = function()
    if not vim.g.persisting then
      return
    end
    local sessionfile = io.open(vim.g.persisted_loaded_session, "r+")
    assert(sessionfile ~= nil)
    local session = sessionfile:read "a"

    -- session = string.gsub(session, "\ncd ", "\ntcd ")
    -- get tab buffer filenames
    local bufs = {}
    for _, bufnr in ipairs(vim.t.bufs) do
      local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:~"):gsub("\\", "/")
      -- remove part that is relative to home dir if applicable
      -- if fname:sub(1, 2) == "~/" then
      --   fname = fname:sub(3, -1);
      -- end
      bufs[fname] = true
    end

    -- Snacks.debug.log(bufs)
    -- get files to remove
    local obsoletefiles = {}
    for fname in session:gmatch "badd%s%+%d+%s([^%s]+)" do
      if bufs[fname] ~= true then
        table.insert(obsoletefiles, fname)
      end
    end
    -- Snacks.debug.log(obsoletefiles)

    for _, fname in ipairs(obsoletefiles) do
      session = session:gsub("badd%s%+%d+%s" .. esc(fname) .. "%s+", "")
    end

    -- Snacks.debug.log(session)

    sessionfile:seek "set"
    sessionfile:write(session)
    sessionfile:flush()
    sessionfile:close()
  end,
}

cmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.signatureHelpProvider then
      require("lsp-overloads").setup(client, {})
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "i",
        "<A-s>",
        "<cmd>LspOverloadsSignature<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        args.buf,
        "n",
        "<A-s>",
        "<cmd>LspOverloadsSignature<CR>",
        { noremap = true, silent = true }
      )
      -- vim.notify "lsp-overloads set up"
    end
    -- print(vim.inspect(args))
    require("which-key").add { require("mappings.util").GetMapsOn("LSP attach", require "mappings"), buffer = args.buf }
  end,
})

cmd("LspNotify", {
  callback = function(args)
    if args.data.method == "textDocument/didOpen" then
      vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
    end
  end,
})
