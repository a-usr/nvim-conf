return {
  {
    "folke/snacks.nvim",
    opts = function()
      ---@module "snacks"
      ---@type snacks.Config
      local opts = {}
      opts.dashboard = require "configs.snackdash"
      opts.notifier = {
        enabled = true,
      }
      opts.words = {
        enabled = true,
      }
      opts.indent = {
        enabled = true,
      }
      opts.dim = {}

      opts.win = {}

      opts.scroll = {
        animate = {
          duration = { step = 15, total = 250 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
        -- what buffers to animate
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
        end,
      }

      ---@type snacks.picker.Config | any
      opts.picker = {
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.8,
              min_width = 120,
              height = 0.8,
              {
                box = "vertical",
                border = "right",
                title = "{source} {live}",
                title_pos = "center",
                { height = 1, border = "none", box = "horizontal" },
                {
                  height = 2,
                  box = "horizontal",
                  { box = "horizontal", width = 5, height = 0.2 },
                  { win = "input", height = 2, border = "none" },
                },
                { win = "list", border = "none" },
              },
              { win = "preview", border = "none", width = 0.5 },
            },
          },
        },
        icons = {
          indent = {
            vertical = "  ",
            middle = "  ",
            last = "  ",
          },
        },
      }

      return opts
    end,
    config = function(plug, opts)
      local snacks = require "snacks"
      snacks.setup(opts)
      vim.ui.select = snacks.picker.select
    end,
    lazy = false,
    priority = 1000,
  },

  {
    "folke/neoconf.nvim",
    config = require "configs.neoconf",
  },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "a-usr/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = true,
  },
  {
    "a-usr/todo.nvim",
    cmd = "Todo",
    opts = {
      opts = {
        file_path = "todo.txt",
      },
    },
    config = function(_, opts)
      require("todo").setup(opts)
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "2kabhishek/nerdy.nvim",
    cmd = "Nerdy",
  },
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
    build = ":TSUpdate",
    config = function(_, opts)
      local configs = require "nvim-treesitter.configs"

      configs.setup(opts)

      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
      parser_configs.lua_patterns = {
        install_info = {
          url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
          files = { "src/parser.c" },
          branch = "main",
        },
      }
    end,
  },

  {
    "olimorris/persisted.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      autostart = true, -- Automatically start the plugin on load?

      -- Function to determine if a session should be saved
      ---@type fun(): boolean
      should_save = function()
        return true
      end,
      -- add any custom options here
      use_git_branch = true,
      ignored_dirs = {
        { "~", exact = true },
      },
    },
    config = function(_, config)
      local persisted = require "persisted"
      persisted.setup(config)
    end,
  },

  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
