-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  statusline = {
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      modalmode = function()
        -- NVchad's Mode implementation, but with support for libmodal modes
        local config = require("nvconfig").ui.statusline
        local utils = require "nvchad.stl.utils"

        local sep_style = config.separator_style
        local sep_icons = utils.separators
        local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
        local sep_r = separators["right"]

        if not utils.is_activewin() then
          return ""
        end

        local modes = utils.modes

        local m = vim.api.nvim_get_mode().mode

        local displaymode = vim.g.libmodalActiveModeName or modes[m][1]

        local current_mode = "%#St_" .. modes[m][2] .. "Mode#  " .. displaymode
        local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_r
        return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
      end,
    },
  },
  tabufline = {
    order = { "neoTreeOffset", "treeOffset", "buffers", "tabs", "btns" },
    modules = {
      neoTreeOffset = function()
        local width = 0
        for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].ft == "neo-tree" then
            width = vim.api.nvim_win_get_width(win)
          end
        end
        return "%#NvimTreeNormal#" .. string.rep(" ", width) .. "│"
      end,
    },
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

M.base46 = {
  theme = "nord",
  transparency = false,

  hl_override = {
    NvDashAscii = { bg = "NONE", fg = "blue" },
    NvDashButtons = { bg = "NONE" },
  },
}

return M
