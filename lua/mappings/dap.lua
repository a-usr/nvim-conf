return require("mappings.util").Map({
	{
		{
			"<leader>",
			{
				"b",
				-- group = "breakpoint", --Group shared with buffer binds (general.lua section tabufline)
				{
					"b",
					function()
						require("dap").toggle_breakpoint()
					end,
					desc = "Breakpoint Toggle",
				},
				{
					"e",
					function()
						require("ui.extBreakpoint")()
					end,
					desc = "Set Advanced Breakpoint Options",
				},
			},
			{
				"d",
				group = "Debug",
				{
					"s",
					function()
						local widgets = require("dap.ui.widgets")
						local view = widgets
							.builder(widgets.sessions)
							.new_win(widgets.with_resize(widgets.new_cursor_anchored_float_win))
							.build()
						view.open()
					end,
				},
				{
					"c",
					function()
						require("dap").continue()
					end,
					desc = "Continue Debugging / Start Session",
				},
				{
					"t",
					function()
						require("dap").terminate()
					end,
					desc = "Terminate debug session",
				},
				{
					"u",
					function()
						require("dap").up()
					end,
					desc = "Walk the stack upwards",
				},
				{
					"d",
					function()
						require("dap").down()
					end,
					desc = "Walk the stack downwards",
				},
			},
		},
	},
	{
		"<M-",
		{
			"s>",
			function()
				require("dap").step_into()
			end,
			desc = "Step into",
		},
		{
			"S>",
			function()
				require("dap").step_over()
			end,
			desc = "Step over",
		},
		{
			"o>",
			function()
				require("dap").step_out()
			end,
		},
		{
			"c>",
			function()
				require("dap").continue()
			end,
			desc = "Continue Debugging",
			-- cond = function()
			--   return require("dap").session() and true or false
			-- end
		},
	},
})
