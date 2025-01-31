local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    ts = { "prettier" },
    js = { "prettier" },
    json = { "prettier" },
    sh = { "shfmt" },
    py = { "black" },
    yaml = { "yamlfmt" },
    toml = { "taplo" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
  },

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}

return options
