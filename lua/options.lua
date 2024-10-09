require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.shell = vim.fn.has("win32") == 1 and "pwsh" or "fish"
