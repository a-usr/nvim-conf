require "nvchad.mappings" --- TODO: remove

-- add yours here
local map = vim.keymap.set
local unmap = vim.keymap.del

local mappinglocs = {
  "lsp",
  "general",
}

local mappings = {} ---@type mapping.proto[]

for _, mappingloc in pairs(mappinglocs) do
  table.insert(mappings, require("mappings." .. mappingloc)) ---@type mapping.proto
end
require("which-key").add(require("mappings.util").GetMapsOnStartup(mappings))

unmap("n", "<leader>ds")

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle Transparency" })

-- LSP mappings

-- Diagnostics
-- map("i", "jk", "<ESC>")

-- DAP

return mappings
