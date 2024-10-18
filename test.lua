local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event
local popup = Popup {
  position = {
    row = 2,
    col = -vim.fn.getcurpos()[3] + 4,
  },
  size = {
    width = 50,
    height = 10,
  },
  enter = true,
  focusable = true,
  zindex = 50,
  anchor = "NW",
  relative = {
    type = "cursor",
  },
  border = {
    padding = {
      top = 0,
      bottom = 2,
      left = 3,
      right = 3,
    },
    style = "rounded",
    text = {
      top = " <---Add Conditional Breakpoint",
      top_align = "left",
      bottom = "I am bottom title",
      bottom_align = "left",
    },
  },
  buf_options = {
    modifiable = true,
    readonly = false,
  },
  win_options = {
    winblend = 10,
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
  },
}

popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
  popup:unmount()
end)
