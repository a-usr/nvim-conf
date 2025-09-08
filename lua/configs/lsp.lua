-- load defaults i.e lua_lsp
vim.lsp.inlay_hint.enable()

local servers = {
	{ "html", {
		cmd = require("configs.os-dependend").lsp.html.cmd,
		filetype = { "html", "razor" },
	} },
	"cssls",
	"qmlls",
	"nixd",
	"nil_ls",
	"jsonls",
	"ts_ls",
	"roslyn",
	"astro",
	"nushell",
	{
		"basedpyright",
		{
			settings = {
				basedpyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						-- Ignore all files for analysis to exclusively use Ruff for linting
						ignore = { "*" },
					},
				},
			},
		},
	},
	"ruff",
	"svelte",
	"hls",
	"rzls",
	"tinymist",
	"lua_ls",
}

local on_attach = function(client, bufnr)
	if client.name == "ruff" then
		-- Disable hover in favor of Basedpyright
		client.server_capabilities.hoverProvider = false
	end
end

vim.lsp.config("*", {
	on_attach = on_attach,
})
-- lsps with default config
for _, lsp in ipairs(servers) do
	if type(lsp) == "string" then
		vim.lsp.enable(lsp)
	else
		assert(type(lsp) == "table", "encountered unexpected config")
		assert(type(lsp[1]) == "string", "encountered unexpected config")
		assert(type(lsp[2]) == "table", "encountered unexpected config")
		vim.lsp.config(lsp[1], lsp[2])
		vim.lsp.enable(lsp[1])
	end
end

--
-- lspconfig.ts_ls.setup {
--   cmd = { "fish", "-NP", "-c", "typescript-language-server --stdio" },
-- }
--
-- lspconfig.astro.setup {
--   cmd = {
--     "",
--     "-NPc",
--     "astro-ls --stdio",
--   },
-- }

-- require("lspconfig").lua_ls.setup {
--   on_attach = on_attach,
--   capabilities = nvlsp.capabilities,
--   on_init = nvlsp.on_init,
--
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim" },
--       },
--       workspace = {
--         library = {
--           vim.fn.expand "$VIMRUNTIME/lua",
--           vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
--           vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
--           vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
--           "${3rd}/luv/library",
--         },
--         maxPreload = 100000,
--         preloadFileSize = 10000,
--       },
--     },
--   },
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
-- lspconfig.omnisharp.setup {
--   on_attach = on_attach,
--   cmd = { "omnisharp" },
--   settings = {
--     FormattingOptions = {
--       -- Enables support for reading code style, naming convention and analyzer
--       -- settings from .editorconfig.
--       EnableEditorConfigSupport = true,
--       -- Specifies whether 'using' directives should be grouped and sorted during
--       -- document formatting.
--       OrganizeImports = nil,
--     },
--     MsBuild = {
--       -- If true, MSBuild project system will only load projects for files that
--       -- were opened in the editor. This setting is useful for big C# codebases
--       -- and allows for faster initialization of code navigation features only
--       -- for projects that are relevant to code that is being edited. With this
--       -- setting enabled OmniSharp may load fewer projects and may thus display
--       -- incomplete reference lists for symbols.
--       LoadProjectsOnDemand = nil,
--     },
--     RoslynExtensionsOptions = {
--       -- Enables support for roslyn analyzers, code fixes and rulesets.
--       EnableAnalyzersSupport = true,
--       -- Enables support for showing unimported types and unimported extension
--       -- methods in completion lists. When committed, the appropriate using
--       -- directive will be added at the top of the current file. This option can
--       -- have a negative impact on initial completion responsiveness,
--       -- particularly for the first few completion sessions after opening a
--       -- solution.
--       EnableImportCompletion = true,
--       -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
--       -- true
--       AnalyzeOpenDocumentsOnly = true,
--     },
--     Sdk = {
--       -- Specifies whether to include preview versions of the .NET SDK when
--       -- determining which version to use for project loading.
--       IncludePrereleases = true,
--     },
--   },
-- }
