local util = require "mappings.util"

return util.Map {
  "<leader>l",
  on = "LSP attach",
  group = "LSP",
  {
    {
      "t",
      function()
        require("lsp_lines").toggle()
      end,
      desc = "Toggle Lsp Lines",
    },
    {
      "d",
      group = "Diagnostics",
      {
        "s",
        function()
          require("trouble").toggle { mode = "diagnostics", filter = { buf = 0 } }
        end,
        desc = "LSP Show Diagnostics for current buffer",
      },
      {
        "l",
        function()
          require("trouble").toggle { mode = "diagnostics" }
        end,
        desc = "LSP Show Diagnostics",
      },
      {
        "a",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "LSP Show Diagnostics in Telescope",
      },
    },
    {
      "s",
      group = "Symbol(s)",
      {
        "l",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "LSP List Document Symbols",
      },
      {
        "r",
        function()
          require "nvchad.lsp.renamer"()
        end,
        desc = "LSP Rename Symbol",
      },
      {
        "h",
        vim.lsp.buf.signature_help,
        desc = "LSP Show Signature Help",
      },
    },
  },
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
