local M = {}

local ns = vim.api.nvim_create_namespace "DapExtBreakpointSetup"
local mark = nil

---comment
---@param components NuiInput[]
local function try_accept(components) end

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

---bind stuff
---@param components NuiInput[]
---@param layout NuiLayout
function M.bind(components, layout)
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
end
return M
