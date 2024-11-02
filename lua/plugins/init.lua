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
    "olimorris/persisted.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    config = function(_, config)
      local persisted = require "persisted"
      persisted.setup(config)
      require("telescope").load_extension "persisted"
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
