return require("mappings.util").Map {
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
}
