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

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
