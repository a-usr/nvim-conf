local M = {
  plugins = {
    neoscroll = {
      enable = true,
    },
    blink = {
      download_fuzzy = true,
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
