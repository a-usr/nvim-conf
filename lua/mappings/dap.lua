return require("mappings.util").Map {
  {
    "b",
    group = "breakpoint",
    {
      "p",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Breakpoint Toggle",
    },
  },
}
