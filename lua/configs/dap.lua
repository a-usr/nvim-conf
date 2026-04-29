local dap = require("dap")

local startUi = function()
	require("dap-view").open()
end
local stopUi = function()
	require("dap-view").close()
end

dap.listeners.before.attach.dapview_config = startUi
dap.listeners.before.launch.dapview_config = startUi

dap.listeners.before.disconnect.dapview_config = stopUi
dap.listeners.before.event_terminated.dapview_config = stopUi
dap.listeners.before.event_exited.dapview_config = stopUi

-- Funky function to assign a value to multpile keys of a table
local function multiassign(inp, tab)
	function asf(item, key)
		if type(item) == "function" then
			tab[key] = item(key)
		else
			tab[key] = item
		end
	end

	for _type, item in pairs(inp) do
		if type(_type) == "table" then
			for _, __type in ipairs(_type) do
				asf(item, __type)
			end
		else
			assert(type(_type) == "string")
			asf(item, _type)
		end
	end
end

local js_types = {
	"msedge",
	"pwa-msedge",
	"node",
	"pwa-node",
	"node-terminal",
	"pwa-chrome",
	"chrome",
}

---@type table<string | string[], dap.Adapter|fun(string): dap.Adapter>
local adapters = {
	[js_types] = function(id)
		return {
			type = "server",
			host = "localhost",
			port = "${port}",
			id = id,
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
	end,
}

multiassign(adapters, dap.adapters)

multiassign(require("configs.os-specializations").dap.adapters, dap.adapters)

local launchjson_type_to_ft = {
	[js_types] = {
		"javascript",
		"typescript",
	},
}
local ext_vscode = require("dap.ext.vscode")
multiassign(launchjson_type_to_ft, ext_vscode.type_to_filetypes)

local getcfgs_orig = ext_vscode.getconfigs

function ext_vscode.getconfigs(path)
	local path = path
	if not path then
		results = vim.fs.find({ ".vscode" }, {
			limit = 1,
			type = "directory",
			path = vim.fn.expand("%:p:h"),
			upward = true,
			stop = vim.fn.fnamemodify(vim.uv.cwd(), ":p:h"),
		})
		path = results[1] and results[1] .. "/launch.json"
	end
	return getcfgs_orig(path)
end
