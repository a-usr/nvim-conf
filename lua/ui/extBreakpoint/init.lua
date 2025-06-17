local Input = require "nui.input"
local Layout = require "nui.layout"

return function()
  local LogMessageValue = ""
  local HitsCountValue = ""
  local ConditionValue = ""

  local breakpoint = {
    condition = "",
    hitCondition = "",
    LogMessage = "",
  }
  local curpos = vim.fn.getcurpos()

  for _, bp in pairs(require("dap.breakpoints").get(vim.api.nvim_get_current_buf())) do
    if not bp[1] then
      goto continue
    end
    bp = bp[1]
    if bp.line == curpos[2] then
      breakpoint = bp
      break
    end
    ::continue::
  end

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
    default_value = breakpoint.logMessage,
    on_close = function()
      print "Input Closed!"
    end,
    on_submit = function(value)
      require("ui.extBreakpoint.behaviour").Accept(value, HitsCountValue, ConditionValue)
    end,
    on_change = function(value)
      LogMessageValue = value
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
    default_value = breakpoint.hitCondition,
    on_close = function()
      print "Input Closed!"
    end,
    on_submit = function(value)
      require("ui.extBreakpoint.behaviour").Accept(LogMessageValue, value, ConditionValue)
    end,

    on_change = function(val)
      local chars = ""
      for char in string.gmatch(val, ".") do
        if string.gmatch(char, "[0-9]")() == char then
          chars = chars .. char
        end
      end
      HitsCountValue = chars
      if string.len(val) ~= string.len(chars) then
        vim.cmd "stopinsert"
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(0, 0, 1, false, { chars })
          vim.cmd "startinsert"
        end)
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
    default_value = breakpoint.condition,
    on_close = function()
      print "Input Closed!"
    end,
    on_submit = function(value)
      require("ui.extBreakpoint.behaviour").Accept(LogMessageValue, HitsCountValue, value)
    end,
    on_change = function(value)
      ConditionValue = value
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
end
