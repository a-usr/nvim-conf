return require("mappings.util").Map {
  {
    "<leader>tt",
    function()
      require("base46").toggle_transparency()
    end,
    desc = "Toggle Transparency",
  },
  {
    "<RightMouse>",
    function()
      vim.cmd.exec '"normal! \\<RightMouse>"'

      local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
      require("menu").open(options, { mouse = true })
    end,
  },
}
