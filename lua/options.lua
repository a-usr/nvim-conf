require "nvchad.options"
local platform_options = require("configs.os-dependend").options
-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
require("lib.shells." .. platform_options.shell)

if vim.fn.has "win32" ~= 0 then
  o.shellslash = true
end
o.sessionoptions = "buffers,curdir,folds,winsize,terminal"
o.foldcolumn = "auto:1"
o.splitkeep = "screen"
