return require("mappings.util").Map({
	{
		"K",
		function()
			local dap = require("dap")
			local session = dap.session()
			if session ~= nil and session.stopped_thread_id ~= nil then
				local hover = require("dap.ui.widgets").hover(nil, {}) ---@as {buf: integer}
				vim.api.nvim_buf_set_keymap(hover.buf, "n", "q", "<cmd>q<CR>", {})
				return
			end

			if (#vim.lsp.get_clients({ bufnr = 0 })) ~= 0 then
				vim.lsp.buf.hover()
				return
			end
		end,
		desc = "(Lsp/Dap) Hover",
	},
	{
		"<C-K>",
		function()
			vim.lsp.buf.hover()
		end,
	},
	{
		"<leader>",
		{
			"t",
			group = "tests/transparancy/theme",
			{
				"l",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "List Tests",
			},
		},
		{
			"r",
			group = "Run",
			{
				"t",
				function()
					require("neotest").run.run()
				end,
				desc = "Run the test under/nearest to the cursor",
			},
			-- {
			--   ""
			-- }
		},
	},
})
