local dap = require "dap"
dap.listeners.before.attach.dapui_config = function()
  require("dapui").open()
end
dap.listeners.before.launch.dapui_config = function()
  require("dapui").open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  require("dapui").close()
end
dap.listeners.before.event_exited.dapui_config = function()
  require("dapui").close()
end

---@type table<string, dap.Adapter|dap.Adapter|fun(callback: fun(adapter: dap.Adapter), config: dap.Configuration, parent?: dap.Session)>>
local adapters = {}

for adapter, config in pairs(adapters) do
  dap.adapters[adapter] = config
end

for adapter, config in pairs(require("configs.os-dependend").dap.adapters) do
  dap.adapters[adapter] = config
end
