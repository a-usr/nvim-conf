local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event
local Input = require "nui.input"
local Layout = require "nui.layout"

local LogMessage = Input({
  position = "50%",
  size = {
    width = 20,
  },
  border = {
    style = "single",
    text = {
      top = " Log Message ",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  prompt = "",
  default_value = "",
  on_close = function()
    print "Input Closed!"
  end,
  on_submit = function(value)
    print("Input Submitted: " .. value)
  end,
})

local HitsCount = Input({
  position = "50%",
  size = {
    width = 20,
  },
  border = {
    style = "single",
    text = {
      top = " Hit Count ",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  prompt = "",
  default_value = "",
  on_close = function()
    print "Input Closed!"
  end,
  on_submit = function(value)
    print("Input Submitted: " .. value)
  end,
})

local Condition = Input({
  position = "50%",
  size = {
    width = 20,
  },
  border = {
    style = "single",
    text = {
      top = " Condition ",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  prompt = "",
  default_value = "",
  on_close = function()
    print "Input Closed!"
  end,
  on_submit = function(value)
    print("Input Submitted: " .. value)
  end,
})

local layout = Layout(
  {
    relative = {
      type = "cursor",
    },
    position = {
      row = 1,
      col = -vim.fn.getcurpos()[3],
    },
    size = {
      width = 80,
      height = "20%",
    },
  },
  Layout.Box({
    Layout.Box({
      -- Layout.Box(popup, { size = "40%" }),
      Layout.Box(Condition, { size = "50%" }),
      Layout.Box(HitsCount, { size = "50%" }),
    }, { dir = "row", size = "30%" }),
    Layout.Box(LogMessage, { size = "50%" }),
  }, { dir = "col" })
)

require("ui.extBreakpoint.behaviour").set_mark()

-- input:mount()
layout:mount()
-- unmount component when cursor leaves buffer

local components = { Condition, HitsCount, LogMessage }

for i, component in pairs(components) do
  component:map("i", "<esc>", function()
    require("ui.extBreakpoint.behaviour").exit_ui(layout)
  end)

  component:map("i", "<Tab>", function()
    local ind = i
    if ind == #components then
      ind = 0
    end
    vim.api.nvim_set_current_win(components[ind + 1].winid)
  end)

  component:map("i", "<S-Tab>", function()
    local ind = i
    if ind == 1 then
      ind = #components + 1
    end
    vim.api.nvim_set_current_win(components[ind - 1].winid)
  end)
end
