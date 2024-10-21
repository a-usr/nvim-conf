local M = {}

local ns = vim.api.nvim_create_namespace "DapExtBreakpointSetup"
local mark = nil

function M.set_mark()
  local pos = vim.fn.getcurpos()
  local row = pos[2] - 1 -- zero-based

  local current_line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)
  local end_col = string.len(current_line[1])

  mark = vim.api.nvim_buf_set_extmark(0, ns, row, 0, { end_col = end_col, end_row = row, hl_group = "IncSearch" })
end

function M.exit_ui(layout)
  layout:unmount()
  assert(mark)
  vim.api.nvim_buf_del_extmark(0, ns, mark)
end

return M
