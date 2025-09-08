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
        args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
      },
    }
  end,
}

multiassign(adapters, dap.adapters)

multiassign(require("configs.os-dependend").dap.adapters, dap.adapters)

local launchjson_type_to_ft = {
  [js_types] = {
    "javascript",
    "typescript",
  },
}

multiassign(launchjson_type_to_ft, require("dap.ext.vscode").type_to_filetypes)
