return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          actions = true,
          -- completion = true,
          hover = true,
        },
      }
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = require("configs.os-dependend").plugins.markdown_preview.build,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
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
  {
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
  },
  -- {
  --   "seblj/roslyn.nvim",
  --   ft = { "cs", "csx" },
  --   opts = {
  --
  --     filewatching = false,
  --
  --     settings = {
  --       ["csharp|background_analysis"] = {
  --         background_analysis = {
  --           dotnet_analyzer_diagnostics_scope = "openFiles",
  --           dotnet_compiler_diagnostics_scope = "openFiles",
  --         },
  --       },
  --       ["csharp|code_lens"] = {
  --         dotnet_enable_references_code_lens = true,
  --         dotnet_enable_tests_code_lens = true,
  --       },
  --       ["csharp|inlay_hints"] = {
  --         csharp_enable_inlay_hints_for_implicit_object_creation = true,
  --         csharp_enable_inlay_hints_for_implicit_variable_types = true,
  --         csharp_enable_inlay_hints_for_lambda_parameter_types = true,
  --         csharp_enable_inlay_hints_for_types = true,
  --         dotnet_enable_inlay_hints_for_indexer_parameters = true,
  --         dotnet_enable_inlay_hints_for_literal_parameters = true,
  --         dotnet_enable_inlay_hints_for_object_creation_parameters = true,
  --         dotnet_enable_inlay_hints_for_other_parameters = true,
  --         dotnet_enable_inlay_hints_for_parameters = true,
  --       },
  --     },
  --   },
  -- },
  {
    "a-usr/csharp.nvim",
    dependencies = {
      "williamboman/mason.nvim", -- Required, automatically installs omnisharp
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
    },
    config = function(_, opts)
      if vim.fn.has "win32" then
        vim.fn.set "noshellslash"
      end
      require "mason" -- Mason setup must run before csharp, only if you want to use omnisharp
      require("csharp").setup(opts)
    end,
    opts = {
      lsp = {
        -- Sets if you want to use omnisharp as your LSP
        omnisharp = {
          cmd_path = "omnisharp.cmd",
          -- When set to false, csharp.nvim won't launch omnisharp automatically.
          enable = true,
          -- The default timeout when communicating with omnisharp
          default_timeout = 1000,
          -- Settings that'll be passed to the omnisharp server
          enable_editor_config_support = true,
          organize_imports = true,
          load_projects_on_demand = false,
          enable_analyzers_support = true,
          enable_import_completion = true,
          include_prerelease_sdks = true,
          -- analyze_open_documents_only = true,
          enable_package_auto_restore = true,
          -- Launches omnisharp in debug mode
          debug = false,
        },
      },
      logging = {
        level = "DEBUG",
      },
      dap = {
        adapter_name = "coreclr",
      },
    },
    ft = "cs",
  },
  {
    "a-usr/nvim-dap-cs",
    opts = {
      netcoredbg = {
        path = "netcoredbg.exe",
      },
    },
    ft = "cs",
  },
  {
    "Issafalcon/neotest-dotnet",
  },
  {

    "nvim-neotest/neotest-python",
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
