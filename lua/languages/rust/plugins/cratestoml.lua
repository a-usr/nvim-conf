return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  config = function()
    require("crates").setup {
      lsp = {
        enabled = true,
        actions = true,
        -- completion = true,
        hover = true,
      },
    }
  end,
}
