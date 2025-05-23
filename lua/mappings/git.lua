return require("mappings.util").Map {
  "<leader>g",
  group = "Git",
  {
    "b",
    "<cmd>Gitsigns blame_line<cr>",
    desc = "Blame Line",
  },
  {
    "B",
    "<cmd>Gitsigns blame<cr>",
    desc = "Blame File",
  },
}
