local _ = require "mason-registry"

local rzls_path = vim.fn.expand "$MASON/packages/rzls/libexec"
local cmd = {
  "roslyn",
  "--stdio",
  "--logLevel=Information",
  "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
  "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
  "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
  "--extension",
  vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
}

return {
  cmd = cmd,
  filetypes = { "cs", "csx", "xaml" },
  handlers = require "rzls.roslyn_handlers",
  settings = {
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
    },
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
      dotnet_enable_inlay_hints_for_indexer_parameters = false,
      dotnet_enable_inlay_hints_for_literal_parameters = false,
      dotnet_enable_inlay_hints_for_object_creation_parameters = false,
      dotnet_enable_inlay_hints_for_other_parameters = false,
      dotnet_enable_inlay_hints_for_parameters = false,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
  },
}
