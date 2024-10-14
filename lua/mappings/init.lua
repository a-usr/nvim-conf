require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set
local unmap = vim.keymap.del


local mappinglocs = {
 "lsp",
}

local mappings = {} ---@type mapping.proto[]

for _, mappingloc in pairs(mappinglocs) do
  table.insert(mappings, require("mappings."..mappingloc)) ---@type mapping.proto
end
require("which-key").add(require("mappings.util").GetMapsOnStartup(mappings))

unmap("n", "<leader>ds")


map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
  end, {desc = "Toggle Transparency"})


-- LSP mappings


-- Diagnostics
map("n", "<leader>ds", function ()
  require("trouble").toggle( {mode = "diagnostics", filter = { buf = 0 }} )
end, {desc = "Diagnostics Show Diagnostics for current buffer"})

map("n", "<leader>dl", function ()
  require("trouble").toggle( {mode = "diagnostics"} )
end, {desc = "Diagnostics Show Diagnostics"})
-- map("i", "jk", "<ESC>")

-- DAP

return mappings
