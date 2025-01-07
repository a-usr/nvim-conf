local M = require "configs.os-dependend.defaults"

M.lsp.jdtls.cmd = {
  "python3",
  "/data/data/com.termux/files/home/.local/share/nvim/mason/packages/jdtls/bin/jdtls",
  "-configuration",
  "/data/data/com.termux/files/home/.cache/jdtls/config",
  "-data",
  "/data/data/com.termux/files/home/.cache/jdtls/workspace",
}
M.options.shell = "nu"
M.options.shellredir = "out+err> %s"
-- M.plugins.neoscroll.enable = false
M.plugins.blink.enable = false
M.plugins.nvim_cmp.enable = true
return M
