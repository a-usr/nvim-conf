if vim.fn.has("win32") == 1 then
	return require("configs.os-specializations.windows")
else
	return require("configs.os-specializations.linux")
end
