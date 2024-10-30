return require("mappings.util").Map {
  {
    "<leader>b",
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
        require "precognition"
        require "ui.extBreakpoint"()
      end,
      desc = "Set Advanced Breakpoint Options",
    },
  },
}
