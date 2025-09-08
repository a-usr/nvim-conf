local util = require "mappings.util"

return util.Map {

	on = "LSP attach",
	{
		"<leader>l",
		group = "LSP",
		{
			{
				"t",
				function()
					require("lsp_lines").toggle()
				end,
				desc = "Toggle Lsp Lines",
			},
			{
				"c",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "Code Actions",
			},
			{
				"d",
				group = "Diagnostics",
				{
					"s",
					function()
						require("trouble").toggle { mode = "diagnostics", filter = { buf = 0 } }
					end,
					desc = "LSP Show Diagnostics for current buffer",
				},
				{
					"l",
					function()
						require("trouble").toggle { mode = "diagnostics" }
					end,
					desc = "LSP Show Diagnostics",
				},
				{
					"a",
					function()
						Snacks.picker.diagnostics()
					end,
					desc = "LSP Show Diagnostics in Picker",
				},
			},
			{
				"s",
				group = "Symbol(s)",
				{
					"l",
					function()
						Snacks.picker.lsp_symbols()
					end,
					desc = "LSP List Document Symbols",
				},
				{
					"r",
					function()
						require "nvchad.lsp.renamer" ()
					end,
					desc = "LSP Rename Symbol",
				},
				{
					"h",
					vim.lsp.buf.signature_help,
					desc = "LSP Show Signature Help",
				},
			},
		},
	},
	{
		"g",
		group = "Go To",
		{
			"d",
			function()
				vim.lsp.buf.definition()
			end,
			desc = "Go to Definition",
		},
		{
			"D",
			function()
				vim.lsp.buf.declaration()
			end,
			desc = "Go to Declaration",
		},
		{
			"i",
			function()
				vim.lsp.buf.implementation()
			end,
			desc = "Go to Implementation",
		},
		{
			"r",
			function()
				vim.lsp.buf.references()
			end,
			desc = "Go to References",
		},
	},
}
