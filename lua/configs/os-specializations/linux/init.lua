local base = require("configs.os-specializations.linux.defaults")
local lazytbl = require("lib.lazy.table")

local function merge(name)
	return lazytbl.mergeRecursively(require("configs.os-specializations.linux." .. name), base)
end

if vim.fn.executable("termux-setup-storage") == 1 then
	return merge("termux")
elseif vim.fn.executable("wslinfo") == 1 then
	return merge("wsl")
elseif vim.system({ "grep", "-e", "^NAME=.*", "/etc/os-release" }):wait().stdout == "NAME=NixOS\n" then
	return merge("nixos")
else
	return base
end
