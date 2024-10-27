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
local HitsCountBuf = 0
local HitsCountNoUpdate = 0
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
  on_change = function(val)
    if HitsCountNoUpdate > 0 then
      HitsCountNoUpdate = HitsCountNoUpdate - 1
      return
    end
    local i = 1
    print(val)
    local chars = ""
    local cursorpos = vim.fn.getcurpos()
    local cursoroffset = 0
    for char in string.gmatch(val, ".") do
      if string.gmatch(char, "[0-9]")() ~= char then
        chars = chars .. char
      else
        if i <= cursorpos[3] - cursoroffset then
          cursoroffset = cursoroffset + 1
        end
      end

      i = i + 1
    end
    print(chars)
    if string.len(val) ~= string.len(chars) then
      local out = string.rep(
        vim.api.nvim_replace_termcodes("<right>", true, true, true),
        string.len(val) - cursorpos[3]
      ) .. string.rep(vim.api.nvim_replace_termcodes("<BS>", true, false, true), string.len(val)) .. chars .. string.rep(
        vim.api.nvim_replace_termcodes("<left>", true, true, true),
        cursorpos[3] - cursoroffset
      )

      HitsCountNoUpdate = string.len(out)
      vim.fn.feedkeys(out)
      -- vim.fn.feedkeys(chars)

      -- if cursoroffset ~= 0 then
      --   vim.fn.cursor(cursorpos[2], cursorpos[3] - cursoroffset)
      -- end
    end
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
      height = 8,
    },
  },
  Layout.Box({
    Layout.Box({
      -- Layout.Box(popup, { size = "40%" }),
      Layout.Box(Condition, { size = "50%" }),
      Layout.Box(HitsCount, { size = "50%" }),
    }, { dir = "row", size = 3 }),
    Layout.Box(LogMessage, { size = "65%" }),
  }, { dir = "col" })
)

require("ui.extBreakpoint.behaviour").set_mark()

-- input:mount()
layout:mount()
HitsCountBuf = HitsCount.bufnr
-- unmount component when cursor leaves buffer

local components = { Condition, HitsCount, LogMessage }

require("ui.extBreakpoint.behaviour").bind(components, layout)
