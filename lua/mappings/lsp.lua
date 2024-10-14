local util = require("mappings.util")

return util.Map {
  "<leader>l",
  on = "LSP attach",
  group = "LSP",

  {
    "d",
    function ()
      require("telescope.builtin").diagnostics()
    end,
    desc = "Show Diagnostics in Telescope"
  },
  {
    "s",
    function ()
      require("telescope.builtin").lsp_document_symbols()
    end,
    desc = "List Document Symbols"
  },
  {
    "r",
    function ()
      require("nvchad.lsp.renamer")()
    end,
    desc = "Rename Symbol"
  }

}

-- return util.MapMany( defaults {
--   {
--     "Show Diagnostics in Telescope",
--     L("ld"),
--     function ()
--       require("telescope.builtin").diagnostics()
--     end
--   },
--   {
--     "List Document Symbols",
--     L("ls"),
--     function ()
--       require("telescope.builtin").lsp_document_symbols()
--     end
--   },
--   {
--     "Rename Symbol",
--     L("lr"),
--     function ()
--       require("nvchad.lsp.renamer")()
--     end
--   }
-- })
