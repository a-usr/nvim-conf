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
      "MunifTanjim/nui.nvim", -- To build the plugin UI
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
  },

  {
    "olimorris/persisted.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
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

  {
    enabled = require("configs.os-dependend").plugins.neoscroll.enable,
    "karb94/neoscroll.nvim",
    event = "BufEnter",
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
      hide_cursor = false, -- hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing = "linear", -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
      performance_mode = false, -- Disable "Performance persisted.de" on all buffers.
      ignored_events = { -- Events ignored while scrolling
        "WinScrolled",
        "CursorMoved",
      },
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
  },
}
