local st, module = pcall(require, "local.localconfig")
if st then
  return module
end
local file = io.open(vim.fn.stdpath "config" .. "/lua/local/localconfig.lua", "w")
assert(file, "I Fell down")
file:write [[
local M = require "local.default"

return M
]]

return require "local.localconfig"
