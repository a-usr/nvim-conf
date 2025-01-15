local UserAutoCmd = function(opts)
  vim.api.nvim_create_autocmd("User", opts)
end

local cmd = vim.api.nvim_create_autocmd

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
        vim.cmd("bd " .. tostring(buffer))
      end)
    end
  end,
}

UserAutoCmd {
  pattern = "PersistedLoadPost",
  callback = function()
    vim.t.persisted_loaded_session = vim.g.persisted_loaded_session
    vim.t.persisting_session = vim.g.persisting_session
  end,
}

UserAutoCmd {
  pattern = "PersistedSavePre",
  callback = function()
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

    session = string.gsub(session, "\ncd ", "\ntcd ")
    -- get tab buffer filenames
    local bufs = {}
    for _, bufnr in ipairs(vim.t.bufs) do
      local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~"):gsub("\\", "/")
      -- remove part that is relative to home dir if applicable
      if fname:sub(1, 2) == "~/" then
        fname = fname:sub(3, -1)
      end
      bufs[fname] = true
    end

    Snacks.debug.log(bufs)
    -- get files to remove
    local obsoletefiles = {}
    for fname in session:gmatch "badd%s%+%d+%s([^%s]+)" do
      Snacks.debug.log(fname)
      if bufs[fname] ~= true then
        table.insert(obsoletefiles, fname)
      end
    end
    Snacks.debug.log(obsoletefiles)

    for _, fname in ipairs(obsoletefiles) do
      session = session:gsub("badd%s%+%d+%s" .. fname .. "%s+", "")
    end

    Snacks.debug.log(session)

    sessionfile:seek "set"
    sessionfile:write(session)
    sessionfile:flush()
    sessionfile:close()
  end,
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_clients({ bufnr = args.buf })[1]
    if client.server_capabilities.signatureHelpProvider then
      require("lsp-overloads").setup(client, {})
      -- vim.notify "lsp-overloads set up"
    end
    -- print(vim.inspect(args))
    require("which-key").add { require("mappings.util").GetMapsOn("LSP attach", require "mappings"), buffer = args.buf }
  end,
})
