return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    cmd = "Telescope",
    config = function ()
      require("telescope").load_extension("ui-select")
    end
  },

  {
  	"nvim-treesitter/nvim-treesitter",
    opts = {
  	  ensure_installed = {
  		  "vim", "lua", "vimdoc",
        "html", "css"
  		},
  	},
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = "SessionManager",
    keys = {
      {"<leader><TAB>l", "<cmd>SessionManager load_session<cr>", desc="SessionManager Load Session"},
      {"<leader><TAB>s", "<cmd>SessionManager save_current_session<cr>", desc="SessionManager Save current Session"},
      {"<leader><TAB>r", "<cmd>SessionManager load_last_session<cr>", desc="SessionManager Load last Session"},
    },
    config = function ()
      local config = require('session_manager.config')
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
      })
    end
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },

  {
    'mfussenegger/nvim-dap',


  },

  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },

  {
    'Iron-E/nvim-libmodal',
    lazy = true, -- don't load until necessary
    --version = '^3.0', -- OPTIONAL: unsubscribe from breaking changes
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
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  --languages
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    'nvim-java/nvim-java'
  }
}
