require "nvchad.options"
local platform_options = require("configs.os-dependend").options
-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
require("lib.shells." .. platform_options.shell)

if vim.fn.has "win32" ~= 0 then
  o.shellslash = true
end
o.sessionoptions = "buffers,curdir,folds,winsize,winpos,skiprtp,resize"
o.foldcolumn = "auto:1"
o.splitkeep = "screen"
o.relativenumber = true
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.lsp.foldexpr()"
