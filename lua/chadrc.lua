-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(
---@type ChadrcConfig

local M = {}
M.nvdash = {
  load_on_startup = false,
}

M.lsp = {
  signature = false,
}
M.ui = {
  statusline = {
    theme = "custom",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor" },
    modules = {},
  },
  tabufline = {
    -- enabled = false,
    -- order = { "neoTreeOffset", "treeOffset", "buffers", "tabs", "btns" },
    -- modules = {
    --   neoTreeOffset = function()
    --     local width = 0
    --     for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    --       if vim.bo[vim.api.nvim_win_get_buf(win)].ft == "neo-tree" then
    --         width = vim.api.nvim_win_get_width(win)
    --       end
    --     end
    --     return "%#NvimTreeNormal#" .. string.rep(" ", width) .. ((width > 0) and "│" or "")
    --   end,
    -- },
  },
}

M.term = {
  float = {
    row = 0.12,
    col = 0.15,
    height = 0.75,
    width = 0.70,
  },
}
local theme = "everforest"
M.base46 = {
  theme = theme,
  transparency = false,
  integrations = {
    "semantic_tokens",
  },
  hl_override = {
    NvDashAscii = { bg = "NONE", fg = "blue" },
    NvDashButtons = { bg = "NONE" },
  },
}

return M
