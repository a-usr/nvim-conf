local signs = {
  "dap",
}

for i, sign in pairs(signs) do
  require("signs." .. sign)
end
