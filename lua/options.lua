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
o.number = true
o.numberwidth = 1

o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.lsp.foldexpr()"

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2

o.clipboard = "unnamedplus"

o.inccommand = "split"

o.ignorecase = true
o.smartcase = true

o.laststatus = 3
o.showmode = false
