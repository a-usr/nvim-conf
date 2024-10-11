require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set
local unmap = vim.keymap.del


local mappinglocs = {
 "lsp",
}

local mappingExports = {} ---@type mappings.mappingProto[]

for _, mappingloc in pairs(mappinglocs) do
  local mappingdefs = require("mappings."..mappingloc) ---@type mappings.mappingProto[]
  for _, mappingdef in pairs(mappingdefs) do

    if mappingdef.mapOn == "startup" then
      require("which-key").add(mappingdef:ToWhickKeySpec())
    else
      table.insert(mappingExports, mappingdef)
    end

  end
end


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

return mappingExports
