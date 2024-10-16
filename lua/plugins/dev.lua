return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },
  {
    "DanWlker/toolbox.nvim",
    opts = {
      commands = require "tools",
    },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      vim.diagnostic.config {
        virtual_text = false,
      }
      require("lsp_lines").setup()
    end,
  },

  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- On musl libc based systems you need to add this flag
    -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',
    opts = {
      keymap = {
        show = "<S-Space>",
        hide = "<ESC>",
        accept = "<CR>",
        select_prev = { "<S-Tab>", "<DOWN>" },
        select_next = { "<Tab>", "<UP>" },

        show_documentation = "<C-d>",
        hide_documentation = "<C-d>",
        scroll_documentation_up = { "<C-b>", "<ScrollWheelUp>" },
        scroll_documentation_down = { "<C-f>", "<ScrollWheelDown>" },

        snippet_forward = "<Tab>",
        snippet_backward = "<S-Tab>",
      },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },

      trigger = {
        completion = {
          blocked_trigger_characters = { " ", "\n", "\t", ",", "'", '"' },
        },
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    },

    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")
      require("blink-cmp").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap",
  },

  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
}
