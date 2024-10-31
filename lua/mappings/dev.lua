return require("mappings.util").Map {
  {
    "<leader>",
    {
      "t",
      group = "tests/toggles/theme",
      {
        "l",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "List Tests",
      },
    },
  },
}
