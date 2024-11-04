local M = require "configs.os-dependend.defaults"

M.plugins.markdown_preview.build = "cd app && yarn install"
M.plugins.direnv.enable = true
M.options.shell = "fish"

return M
