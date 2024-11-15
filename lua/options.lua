require "nvchad.options"
local platform_options = require("configs.os-dependend").options
-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.shell = platform_options.shell
o.shellcmdflag = platform_options.shellcmdflag
o.shellxquote = platform_options.shellxquote
o.shellslash = platform_options.shellslash
o.sessionoptions = "buffers,curdir,folds,winsize,terminal"
o.foldcolumn = "auto:1"
