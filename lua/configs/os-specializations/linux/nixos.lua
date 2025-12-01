local M = require("configs.os-specializations.defaults").new()

M.plugins.markdown_preview.build = "cd app && yarn install"
M.plugins.direnv.enable = true
M.options.shell = "nushell"

return M
