---@module "trouble"
return {
  {
    "folke/trouble.nvim",

    cond = not vim.g.vscode,

    ---@type trouble.Config
    opts = {
      modes = {
        ---@type trouble.Mode
        -- lsp_base = {
        --   preview = {
        --     type = "float",
        --     relative = "editor",
        --     border = "rounded",
        --     title = "Preview",
        --     title_pos = "center",
        --     position = { 0, -2 },
        --     size = { width = 0.3, height = 0.3 },
        --     zindex = 200,
        --   },
        -- },
      },
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },
  {
    "DanWlker/toolbox.nvim",
    opts = {
      commands = require "tools",
    },
  },

  { "Issafalcon/lsp-overloads.nvim", config = false },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "BufEnter",
    config = function()
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = false,
      }
      require("lsp_lines").setup()
    end,
  },

  {
    -- enabled = require("configs.os-dependend").plugins.blink.enable,
    "Saghen/blink.cmp",
    event = "InsertEnter",
    cond = not vim.g.vscode,
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
        [require("configs.os-dependend").custom.completionOpen] = { "show" },
        ["<ESC>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<UP>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<DOWN>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-d>"] = { "show_documentation", "hide_documentation" },
        -- scroll_documentation_up = { "<C-b>", "<ScrollWheelUp>" },
        -- scroll_documentation_down = { "<C-f>", "<ScrollWheelDown>" },
        cmdline = {
          [require("configs.os-dependend").custom.completionOpen] = { "show" },
          ["<ESC>"] = {
            function(cmp)
              if cmp.is_visible() then
                cmp.cancel()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
              end
            end,
          },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },
      },

      appearance = {
        nerd_font_variant = "normal",
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },

      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        -- menu = {
        --   auto_show = function(ctx)
        --     return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        --   end,
        -- },
        trigger = {
          show_on_blocked_trigger_characters = function()
            if vim.api.nvim_get_mode().mode == "c" then
              return {}
            end

            -- you can also block per filetype, for example:
            -- if vim.bo.filetype == 'markdown' then
            --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
            -- end

            return { "\n", "\t" }
          end,

          -- blocked_trigger_characters = { " ", "\n", "\t", ",", "'", '"' },
        },
      },
      -- fuzzy = {
      --   prebuiltBinaries = {
      --     download = true,
      --   },
      -- },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      -- nerd_font_variant = "normal",

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
    config = function()
      require "configs.dap"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neoconf.nvim" },
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
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
  {
    enabled = require("configs.os-dependend").plugins.direnv.enable,
    "direnv/direnv.vim",
    lazy = false,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = require "configs.neotest",
  },
}
