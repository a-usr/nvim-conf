local PersistedAutoCmd = function(opts)
  vim.api.nvim_create_autocmd("User", opts)
end

local cmd = vim.api.nvim_create_autocmd

PersistedAutoCmd {
  pattern = "PersistedStart",
  callback = function()
    vim.t.persisting = true
  end,
}

cmd("TabLeave", {
  callback = function()
    if vim.t.persisting then
      vim.schedule(function()
        -- vim.notify "Session Saved"
      end)
      require("persisted").save()
    end
  end,
})

PersistedAutoCmd {
  pattern = "PersistedLoadPre",
  callback = function()
    vim.cmd "silent! lua vim.api.nvim_del_augroup_by_name('NvdashAu')"
    for _, buffer in pairs(vim.t.bufs or {}) do
      vim.schedule(function()
        vim.cmd("bd " .. tostring(buffer))
      end)
    end
  end,
}

PersistedAutoCmd {
  pattern = "PersistedLoadPost",
  callback = function()
    vim.t.persisted_loaded_session = vim.g.persisted_loaded_session
    vim.t.persisting_session = vim.g.persisting_session
  end,
}

PersistedAutoCmd {
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

PersistedAutoCmd {
  pattern = "PersistedSavePost",
  callback = function()
    if not vim.g.persisting then
      return
    end
    local sessionfile = io.open(vim.g.persisted_loaded_session, "r+")
    assert(sessionfile ~= nil)
    local sessionscript = sessionfile:read "a"
    sessionfile:seek "set"
    sessionfile:write(string.gsub(sessionscript, "\ncd ", "\ntcd "))
    sessionfile:flush()
    sessionfile:close()
  end,
}
