local config = require("nvconfig").ui.statusline
local sep_style = config.separator_style
local utils = require "nvchad.stl.utils"

sep_style = (sep_style ~= "round" and sep_style ~= "block") and "block" or sep_style

local sep_icons = utils.separators
local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]

local sep_l = separators["left"]
local sep_r = "%#St_sep_r#" .. separators["right"] .. " %#ST_EmptySpace#"

local function gen_block(icon, txt, sep_l_hlgroup, iconHl_group, txt_hl_group)
  return (icon ~= nil and sep_l_hlgroup .. sep_l .. iconHl_group .. icon .. " " or "")
    .. txt_hl_group
    .. " "
    .. txt
    .. sep_r
end

local is_activewin = utils.is_activewin

local M = {}

M.mode = function()
  if not is_activewin() then
    return ""
  end

  local modes = utils.modes
  local m = vim.api.nvim_get_mode().mode
  local current_mode = "%#St_" .. modes[m][2] .. "Mode# " .. modes[m][1] .. " "
  local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. " "
  return current_mode .. mode_sep1
  -- return gen_block(
  --   nil,
  --   modes[m][1],
  --   "%#St_" .. modes[m][2] .. "ModeSep#",
  --   "%#St_" .. modes[m][2] .. "ModeText#",
  --   "%#St_" .. modes[m][2] .. "Mode#"
  -- )
end

M.file = function()
  local x = utils.file()
  return gen_block(x[1], x[2], "%#St_file_sep#", "%#St_file_bg#", "%#St_file_txt#")
end

M.git = function()
  return "%#St_gitIcons#" .. utils.git()
end

M.lsp_msg = function()
  return "%#St_LspMsg#" .. utils.lsp_msg()
end

M.diagnostics = utils.diagnostics

M.lsp = function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if clients[1] == nil then
    return ""
  end
  local client = clients[1]

  -- return "%#St_Lsp#" .. client.name .. " "
  return gen_block(
    "",
    client.name .. (clients[2] ~= nil and " +" or ""),
    "%#St_lsp_sep#",
    "%#St_lsp_bg#",
    "%#St_lsp_txt#"
  )
end

M.cwd = function()
  local name = vim.uv.cwd()
  name = name:match "([^/\\]+)[/\\]*$" or name
  return gen_block("", name, "%#St_cwd_sep#", "%#St_cwd_bg#", "%#St_cwd_txt#")
end

M.cursor = function()
  return gen_block("", "%l/%v", "%#St_Pos_sep#", "%#St_Pos_bg#", "%#St_Pos_txt#")
end

M["%="] = "%="

return function()
  return utils.generate("default", M)
end
