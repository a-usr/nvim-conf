
local M = {
  lsp = {
    jdtls = {
      cmd = { "jdtls" }
    }
  }
}
M.__index = M
return setmetatable({}, M)
