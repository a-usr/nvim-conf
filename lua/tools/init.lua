---@type toolbox.command[]
return {
  {
    name = "Format",
    execute = function()
      require("conform").format()
    end,
    require_input = false,
  },
}

---@class toolbox.command
---@field name string
---@field execute string|function
---@field require_input boolean
