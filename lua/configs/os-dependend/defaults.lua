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
