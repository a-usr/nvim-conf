return {
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup({
				-- Your config here
				background = "hard",
			})
		end,
	},
	{
		"0xstepit/flow.nvim",
		lazy = false,
		priority = 1000,
		-- tag = "v2.0.2",
		opts = {
			-- Your configuration options here.
			ui = {
				borders = "inverse",
				aggressive_spell = false,
			},
		},
		config = function(_, opts)
			require("flow").setup(opts)
			vim.cmd("colorscheme flow")

			local colors = require("flow.colors").colors

			local highlights = {
				DevIconCs = {
					bg = colors.bg,
					fg = colors.purple,
				},
				["@keyword.function"] = {
					link = "@keyword",
				},
			}

			for hl, value in pairs(highlights) do
				vim.api.nvim_set_hl(0, hl, value)
			end
		end,
	},
}
