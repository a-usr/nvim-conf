vim.cmd "runtime colors/flow"
local colors = require("flow.colors").colors

local highlights = {
  DevIconCs = {
    bg = colors.purple,
    fg = colors.bg,
  },
}

for hl, value in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl, value)
end
