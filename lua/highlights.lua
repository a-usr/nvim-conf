local M = {}

---@type Base46HLGroupsList
M.override = {
  NvDashAscii = { bg = "NONE", fg = "blue" },
  NvDashButtons = { bg = "NONE" },
}

vim.api.nvim_set_hl(0, "Breakpoint", {
  fg = require("base46").get_theme_tb("base_30").red,
})

vim.api.nvim_set_hl(0, "DapStopped", {
  fg = require("base46").get_theme_tb("base_30").green,
})

return M
