
local M = {
  lsps = {
    jdtls = {
      cmd = { "jdtls" }
    }
  }
}
M.__index = M
return setmetatable({}, M)
