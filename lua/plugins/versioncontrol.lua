return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
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
