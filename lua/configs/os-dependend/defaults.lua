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
