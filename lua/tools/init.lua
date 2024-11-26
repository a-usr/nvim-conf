---@type toolbox.command[]
return {

  {
    name = "Timer",
    execute = function()
      require("timerly").open()
    end,
    require_input = false,
  },
  {
    name = "Format",
    execute = function()
      require("conform").format()
    end,
    require_input = false,
  },
  {
    name = "Show Nerd Font Symbols",
    execute = "Nerdy",
    require_input = false,
  },
  {
    name = "Open Lazy",
    execute = "Lazy",
    require_input = false,
  },
  {
    name = "Todo List",
    execute = "Todo",
    require_input = false,
  },
}

---@class toolbox.command
---@field name string
---@field execute string|function
---@field require_input boolean
