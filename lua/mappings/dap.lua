return require("mappings.util").Map {
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
            require "precognition"
            require "ui.extBreakpoint" ()
          end,
          desc = "Set Advanced Breakpoint Options",
        },
      },
      {
        "d",
        group = "dap",
        {
          "c",
          function()
            require("dap").continue()
          end,
          desc = "Continue Debugging / Start Session"
        },
        {
          "t",
          function()
            require("dap").terminate()
          end,
          desc = "terminate session",
        },
        {
          "u",
          function()
            require("dap").up()
          end,
          desc = "walk the stack upwards"
        },
        {
          "d",
          function()
            require("dap").down()
          end,
          desc = "walk the stack downwards"
        }
      }
    },
  },
  {
    "<M-",
    {
      "s>",
      function()
        require("dap").step_into()
      end,
      desc = "Step into"
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
    }

  }
}
