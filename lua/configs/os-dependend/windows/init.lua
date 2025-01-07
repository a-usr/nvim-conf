local M = require "configs.os-dependend.defaults"

--- HACK: On Windows Terminal I bound <C-Space> to F13, as <C-Space> wouldnt emit for some reason
M.custom.completionOpen = "<F13>"
M.options.shell = "nu"
M.options.shellredir = "out+err> %s"
-- M.options.shellcmdflag =
--   "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
M.options.shellslash = false
M.plugins.nvim_java.enable = false
return M
