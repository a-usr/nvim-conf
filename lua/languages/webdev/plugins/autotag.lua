return {
  "windwp/nvim-ts-autotag",
  ft = { "typescript", "js", "html", "xhtml", "javascriptreact", "typescriptreact", "xml" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
