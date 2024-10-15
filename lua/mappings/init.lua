--require "nvchad.mappings" --- TODO: remove

-- add yours here

local mappinglocs = {
  "lsp",
  "general",
  "windows",
}

local mappings = {} ---@type mapping.proto[]

for _, mappingloc in pairs(mappinglocs) do
  table.insert(mappings, require("mappings." .. mappingloc)) ---@type mapping.proto
end
require("which-key").add(require("mappings.util").GetMapsOnStartup(mappings))

-- LSP mappings

-- Diagnostics
-- map("i", "jk", "<ESC>")

-- DAP

return mappings
