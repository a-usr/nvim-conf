return {

  {
    "OXY2DEV/markview.nvim",
    -- lazy = false,      -- Recommended
    ft = { "markdown", "typst" }, -- If you decide to lazy-load anyway
    main = "markview",
    opts = {
      preview = {
        modes = { "n", "no", "c", "i" },
        hybrid_modes = { "i" },
        -- edit_range = { 1, 1 },
      },
      markdown = {
        enable = true,
        code_blocks = {
          style = "simple",
        },
      },
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {

      dependencies_bin = {
        ["tinymist"] = "tinymist",
        ["websocat"] = "websocat",
      },
    }, -- lazy.nvim will implicitly calls `setup {}`
  },
}
