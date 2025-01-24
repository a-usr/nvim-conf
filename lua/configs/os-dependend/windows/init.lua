local M = require "configs.os-dependend.defaults"

--- HACK: On Windows Terminal I bound <C-Space> to F13, as <C-Space> wouldnt emit for some reason
M.custom.completionOpen = "<F13>"
M.options.shell = "nushell"

M.plugins.nvim_java.enable = false
return M
