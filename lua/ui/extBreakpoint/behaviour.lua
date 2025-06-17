local M = {}

local ns = vim.api.nvim_create_namespace "DapExtBreakpointSetup"
local mark = nil
local bufnr = 0
local layout = {}

---comment
---@param MessageVal string
---@param HitCountVal string
---@param ConditionVal string
function M.Accept(MessageVal, HitCountVal, ConditionVal)
  M.exit_ui()
  require("dap").set_breakpoint(ConditionVal, HitCountVal, MessageVal)
end

function M.set_mark()
  bufnr = vim.fn.bufnr()
  local pos = vim.fn.getcurpos()
  local row = pos[2] - 1 -- zero-based

  local current_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)
  local end_col = string.len(current_line[1])

  mark = vim.api.nvim_buf_set_extmark(0, ns, row, 0, { end_col = end_col, end_row = row, hl_group = "IncSearch" })
end

function M.exit_ui()
  layout:unmount()
  assert(mark)
  vim.api.nvim_buf_del_extmark(bufnr, ns, mark)
  vim.api.nvim_set_current_win(vim.fn.bufwinid(bufnr))
end

---bind stuff
---@param components NuiInput[]
---@param Layout NuiLayout
function M.bind(components, Layout)
  layout = Layout
  for i, component in pairs(components) do
    local next = i == #components and 1 or i + 1
    local prev = i == 1 and #components or i - 1
    component:map("i", "<esc>", function()
      require("ui.extBreakpoint.behaviour").exit_ui()
    end)

    component:map("i", "<Tab>", function()
      vim.api.nvim_set_current_win(components[next].winid)
    end)

    component:map("i", "<S-Tab>", function()
      vim.api.nvim_set_current_win(components[prev].winid)
    end)
  end
end
return M
