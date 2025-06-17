return {
  "nvim-java/nvim-java",
  enabled = require("configs.os-dependend").plugins.nvim_java.enable,
  opts = {
    jdk = {
      -- install jdk using mason.nvim
      auto_install = false,
    },
    spring_boot_tools = {
      enable = false,
    },
  },
  config = function(_, opts)
    require("java").setup(opts)
  end,
}
