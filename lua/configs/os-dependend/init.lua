

if vim.fn.has("win32")==1 then
  return require("configs.os-dependend.windows")
else
  if vim.fn.executable("termux-setup-storage") then
    return require("configs.os-dependend.termux")
  else
    if vim.system({"rg", "-x", "NAME=(.*)"}) == "NAME=NixOS" then
      return require("configs.os-dependend.nixos")
    else
      return require("configs.os-dependend.linux")
    end
  end
end

