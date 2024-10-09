require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

--map leader+lhs in normal mode
---@param lhs string
---@param rhs string | function
---@param opts? vim.keymap.set.Opts
local function mapnleader(lhs, rhs, opts)
  map("n", "<leader>"..lhs, rhs, opts)
end


unmap("n", "<leader>ds")

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
  end, {desc = "Toggle Transparency"})


-- LSP mappings

map("n","<leader>ld", function ()
  require("telescope.builtin").diagnostics()
end, {desc = "LSP Show Diagnostics in Telescope"})

map("n", "<leader>ls", function ()
  require("telescope.builtin").lsp_document_symbols()
end, {desc = "LSP List Document Symbols"})

map("n", "<leader>lS", function ()
  require("telescope.builtin").lsp_references()
end, {desc = "LSP Show Symbol References"})

mapnleader("lr", function ()
  require("nvchad.lsp.renamer")()
end, { desc = "LSP Rename Symbol"})


-- Diagnostics
map("n", "<leader>ds", function ()
  require("trouble").toggle( {mode = "diagnostics", filter = { buf = 0 }} )
end, {desc = "Diagnostics Show Diagnostics for current buffer"})

map("n", "<leader>dl", function ()
  require("trouble").toggle( {mode = "diagnostics"} )
end, {desc = "Diagnostics Show Diagnostics"})
-- map("i", "jk", "<ESC>")

-- DAP

--mapnleader("")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
