return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
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
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    opts = {

      filewatching = false,

      settings = {
        ["csharp|background_analysis"] = {
          background_analysis = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
          dotnet_enable_tests_code_lens = true,
        },
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
        },
      },
    },
  },

  {
    "nicholasmata/nvim-dap-cs",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "cs",
    config = function()
      require("dap-cs").setup()
    end,
  },
  {
    "Issafalcon/neotest-dotnet",
  },
  {

    "nvim-neotest/neotest-python",
  },
}
