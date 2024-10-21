local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event
local Input = require "nui.input"
local Layout = require "nui.layout"

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
      top = " <---Add Extended Breakpoint",
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

local input = Input({
  relative = {
    type = "win",
    winid = popup.winid,
  },
  position = "50%",
  size = {
    width = 20,
  },
  border = {
    style = "single",
    text = {
      top = "[Howdy?]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  prompt = "> ",
  default_value = "Hello",
  on_close = function()
    print "Input Closed!"
  end,
  on_submit = function(value)
    print("Input Submitted: " .. value)
  end,
})

local layout = Layout(
  {
    position = 0,
    size = {
      width = 80,
      height = "60%",
    },
  },
  Layout.Box({
    -- Layout.Box(popup, { size = "40%" }),
    Layout.Box(input, { size = "60%" }),
  }, { dir = "row" })
)
popup:mount()
layout:update {
  relative = {
    type = "win",
    winid = popup.winid,
  },
}
-- input:mount()
vim.schedule(function()
  layout:mount()
end)
-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
  popup:unmount()
end)

popup:map("n", "<esc>", function()
  popup:unmount()
end)
