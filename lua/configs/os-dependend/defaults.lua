local M = {
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
