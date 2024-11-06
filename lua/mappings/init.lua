-- add yours here

local mappinglocs = {
  "lsp",
  "general",
  "windows",
  "dap",
  "dev",
}

local mappings = {} ---@type mapping.proto[]

for _, mappingloc in pairs(mappinglocs) do
  table.insert(mappings, require("mappings." .. mappingloc)) ---@type mapping.proto
end
require("which-key").add(require("mappings.util").GetMapsOnStartup(mappings))

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- print(vim.inspect(args))
    require("which-key").add { require("mappings.util").GetMapsOn("LSP attach", mappings), buffer = args.buf }
  end,
})

-- LSP mappings

-- Diagnostics
-- map("i", "jk", "<ESC>")

-- DAP

return mappings
