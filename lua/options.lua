require "nvchad.options"
local platform_options = require("configs.os-dependend").options
-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.shell = platform_options.shell
