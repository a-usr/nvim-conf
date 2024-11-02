---@module "dap"
local M = {
  plugins = {
    neoscroll = {
      enable = true,
    },
    blink = {
      enable = true,
    },
    nvim_cmp = {
      enable = false,
    },
    nvim_java = {
      enable = true,
    },
    markdown_preview = {
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
    },
  },

  dap = {

    ---@type table<string, dap.Adapter|dap.Adapter|fun(callback: fun(adapter: dap.Adapter), config: dap.Configuration, parent?: dap.Session)>>
    adapters = {},
  },

  options = {
    shell = "bash",
  },
  lsp = {
    jdtls = {
      cmd = { "jdtls" },
    },
  },
}
M.__index = M
return setmetatable({}, M)
