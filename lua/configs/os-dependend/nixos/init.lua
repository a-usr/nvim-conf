local M = require "configs.os-dependend.defaults"

M.plugins.markdown_preview.build = "cd app && yarn install"
M.plugins.direnv.enable = true
M.options.shell = "nu"
M.options.shellredir = "out+err> %s"

return M
