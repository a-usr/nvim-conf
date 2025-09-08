local lazydev = require("lazydev.lsp")
return {
	on_attach = lazydev.attach,
	settings = {
		Lua = {
			hint = {
				enable = true,
				paramType = false,
				paramName = "Disable",
			},
		},
	},
}
