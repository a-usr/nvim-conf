
local M = require("configs.os-dependend.defaults")

M.lsps.jdtls.cmd = {
    "python3",
    "/data/data/com.termux/files/home/.local/share/nvim/mason/packages/jdtls/bin/jdtls",
    "-configuration",
    "/data/data/com.termux/files/home/.cache/jdtls/config",
    "-data",
    "/data/data/com.termux/files/home/.cache/jdtls/workspace" }

return M
