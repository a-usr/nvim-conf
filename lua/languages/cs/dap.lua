local lazy = require("lib.lazy.deferred")

lazy.wrap(function(ctx)
	local dap = ctx:await("dap")

	local nvim_data = vim.fn.stdpath("data")

	local vsda = nvim_data .. "/vsda/"

	-- vsdbg certification
	local function send_payload(client, payload)
		local msg = require("dap.rpc").msg_with_content_length(vim.json.encode(payload))
		client.write(msg)
	end

	local SIGNJS = vsda .. "vsda.js"

	function RunHandshake(self, request_payload)
		local signResult = io.popen("node " .. SIGNJS .. " " .. request_payload.arguments.value)
		if signResult == nil then
			require("dap.utils").notify("error while signing handshake", vim.log.levels.ERROR)
			return
		end
		local signature = signResult:read("*a")
		signature = string.gsub(signature, "\n", "")
		local response = {
			type = "response",
			seq = 0,
			command = "handshake",
			request_seq = request_payload.seq,
			success = true,
			body = {
				signature = signature,
			},
		}
		send_payload(self.client, response)
	end

	dap.adapters.coreclr = {
		id = "coreclr",
		type = "executable",
		command = vsda .. "vsdbg/vsdbg.exe",
		args = {
			"--interpreter=vscode",
			-- "--engineLogging",
			-- "--consoleLogging",
		},
		options = {
			externalTerminal = false,
		},
		runInTerminal = true,
		reverse_request_handlers = {
			handshake = RunHandshake,
		},
	}

	dap.configurations.cs = {
		type = "coreclr",
		name = "Launch",
		request = "launch",
		program = "dotnet exe path", -- Note: Please include the actual path!
		args = {},
		cwd = vim.fn.getcwd(),
		clientID = "vscode",
		clientName = "Visual Studio Code",
		externalTerminal = true,
		columnsStartAt1 = true,
		linesStartAt1 = true,
		locale = "en",
		pathFormat = "path",
		externalConsole = true,
	}
end)
