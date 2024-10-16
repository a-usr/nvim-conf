local cmd = function(opts)
  vim.api.nvim_create_autocmd("User", opts)
end

cmd {
  pattern = "PersistedSavePre",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].filetype == "NvimTree" or vim.bo[buf].filetype == "neo-tree" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
}

cmd {
  pattern = "PersistedLoadPre",
  callback = function()
    vim.cmd "silent! lua vim.api.nvim_del_augroup_by_name('NvdashAu')"
    vim.cmd "tabnew|-tabc"
  end,
}
-- cmd {
--   pattern = "PersistedSavePost",
--   callback = function ()
--     vim.cmd "%bd|"
--   end
-- }
