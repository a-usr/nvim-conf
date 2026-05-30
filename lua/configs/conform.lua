local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "biome" },
		html = { "biome" },
		typescript = { "biome", "biome-organize-imports" },
		typescriptreact = { "biome", "biome-organize-imports" },
		javascript = { "biome", "biome-organize-imports" },
		javascriptreact = { "biome", "biome-organize-imports" },
		json = { "biome" },
		sh = { "shfmt" },
		python = { "black" },
		yaml = { "yamlfmt" },
		toml = { "taplo" },
		rust = { "rustfmt" },
		nix = { "nixfmt" },
	},

	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 1100, lsp_fallback = true }
	end,
	log_level = vim.log.levels.DEBUG,
}

return options
