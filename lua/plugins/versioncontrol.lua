return {
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
	},
	{
		"akinsho/git-conflict.nvim",
		event = "BufReadPost",
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- numhl = true,
		},
		event = "BufEnter",
	},
}
