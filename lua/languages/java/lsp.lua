local javasetup = false
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.java",
  callback = function()
    if javasetup then
      return
    end
    javasetup = true
    require "java"
    vim.lsp.enable "jdtls"
  end,
})
