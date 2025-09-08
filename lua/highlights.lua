-- vim.api.nvim_set_hl(0, "Breakpoint", {
--   fg = require("base46").get_theme_tb("base_30").red,
-- })
--
-- vim.api.nvim_set_hl(0, "DapStopped", {
--   fg = require("base46").get_theme_tb("base_30").green,
-- })
local highlights = {
  ["@lsp.type.extensionMethod"] = {
    link = "@lsp.type.method",
  },
  VisualNonText = vim.api.nvim_get_hl(0, { name = "Visual" }),
}

for hl, value in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl, value)
end

require("ripped.highlights").setup()
