vim.filetype.add {
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
}

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
}

vim.env.EDITOR = "nvr --remote-wait-silent -l "

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if syntax == "markdown" then
    vim.bo[bufnr].syntax = "lsp_markdown"
    vim.wo[winnr].linebreak = true
    vim.wo[winnr].signcolumn = "no"
    vim.wo[winnr].conceallevel = 3
    require("markview").render(bufnr, { enable = true, hybrid_mode = false })
  end
  return bufnr, winnr
end
