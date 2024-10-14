return {
  -- These are some examples, uncomment them if you want to see them work!

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = "SessionManager",
    keys = {
      { "<leader><TAB>l", "<cmd>SessionManager load_session<cr>", desc = "SessionManager Load Session" },
      {
        "<leader><TAB>s",
        "<cmd>SessionManager save_current_session<cr>",
        desc = "SessionManager Save current Session",
      },
      { "<leader><TAB>r", "<cmd>SessionManager load_last_session<cr>", desc = "SessionManager Load last Session" },
    },
    config = function()
      local config = require "session_manager.config"
      require("session_manager").setup {
        autoload_mode = config.AutoloadMode.Disabled,
      }
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
