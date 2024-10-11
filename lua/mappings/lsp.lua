local util = require("mappings.util")
local L = util.L

---@param o mappings.util.mapping[]
local function defaults(o)
  for _, bind in ipairs(o) do
    bind.category = bind.category or "LSP"
    bind.on = bind.on or "LSP attach"
  end
  return o
end

return util.MapMany( defaults {
  {
    "Show Diagnostics in Telescope",
    L("ld"),
    function ()
      require("telescope.builtin").diagnostics()
    end
  },
  {
    "List Document Symbols",
    L("ls"),
    function ()
      require("telescope.builtin").lsp_document_symbols()
    end
  },
  {
    "Rename Symbol",
    L("lr"),
    function ()
      require("nvchad.lsp.renamer")()
    end
  }
})
