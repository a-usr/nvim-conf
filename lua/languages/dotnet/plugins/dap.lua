return {
	"a-usr/nvim-dap-cs",
	opts = {
		setup_adapter = false,
	},

	config = function(_, opts)
		require("dap-cs").setup(opts)
		require("lib.lazy.deferred").notify("dap-cs")
	end,
	ft = { "cs", "xaml" },
}
