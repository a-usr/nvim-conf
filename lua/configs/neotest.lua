local patterns = {}

local set_confs = function()
  patterns = require("neoconf").get("python.testing.filePatterns", { "test_.*%.py" })
  -- vim.notify(vim.inspect(patterns))
end
vim.api.nvim_create_autocmd("DirChanged", {
  callback = set_confs,
})

return function()
  set_confs()
  require("neotest").setup { ---@diagnostic disable-line:missing-fields
    quickfix = { ---@diagnostic disable-line:missing-fields
      enabled = true,
    },
    log_level = 1,
    adapters = {
      require "neotest-dotnet" {
        discovery_root = "solution",
      },
      require "neotest-python" {
        python = "python",
        args = require("neoconf").get("vscode.python.testing.pytestArgs", {}),
        runner = "pytest",
        pytest_discover_instances = true,
        is_test_file = function(file_path)
          if not vim.endswith(file_path, ".py") then
            return false
          end
          -- vim.notify(file_path)
          for _, pattern in pairs(patterns) do
            -- vim.notify(pattern)
            if file_path:match(pattern) then
              -- vim.notify(file_path)
              return true
            end
          end
          return false
        end,
      },
      require "rustaceanvim.neotest",
    },
  }
end
