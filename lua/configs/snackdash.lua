local a = require "plenary.async"
local lazy_stats = require("lazy.stats").stats()
local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)

local img = nil
local imgloaded = false
local function GetDashImage()
  ---@diagnostic disable-next-line
  local path = string.gsub(vim.fn.stdpath "cache", "([^A-Z][^:])\\", "%1/") .. "/dashimgs"
  a.run(function()
    local dir = a.uv.fs_stat(path)
    if not (dir and dir.type == "directory") then
      a.uv.fs_mkdir(path, 755)
    end

    local files = {}
    local dd, err = vim.loop.fs_opendir(path, nil, 99)
    assert(not err, err)
    local err, res = a.uv.fs_readdir(dd)
    assert(not err, vim.inspect(err))

    for _, file in pairs(res) do
      if file.type == "file" then
        table.insert(files, file.name)
      end
    end
    return files
  end, function(files)
    img = files[math.random(#files)]
    imgloaded = true
  end)
  local _img
  if vim.fn.has "WIN32" then
    img = vim.system {
      "pwsh",
      "-NoProfile",
      "-NonInteractive",
      "-c",
      "ls " .. vim.fn.stdpath "data" .. "\\DashImgs | Get-Random | Select -ExpandProperty FullName | Write-Output",
    }
  else
    _img = vim.system {

      "bash",
      "-c",
      "ls " .. vim.fn.stdpath "data" .. "\\DashImgs | sort -R | tail -n 1 ",
    }
  end

  return string.gsub(_img:wait().stdout, "^%s*(.-)%s*$", "%1")
end

---@type snacks.dashboard.Config
local cfg = {
  preset = {
    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
    ---@type fun(cmd:string, opts:table)|nil
    pick = nil,
    -- Used by the `keys` section to show keymaps.
    -- Set your custom keymaps here.
    -- When using a function, the `items` argument are the default keymaps.
    -- stylua: ignore
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    -- Used by the `header` section
    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  },
  -- item field formatters
  formats = {
    icon = function(item)
      if item.file and item.icon == "file" or item.icon == "directory" then
        return require("snacks.dashboard").icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = "NvDashButtons" }
    end,
    footer = { "%s", align = "center", hl = "NvDashFooter" },
    desc = { "%s", align = "left", hl = "NvDashButtons" },
    header = { "%s", align = "center", hl = "NvDashAscii" },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ":~")
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      local dir, file = fname:match "^(.*)/(.+)$"
      return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "NvDashButtons" } }
    end,
  },
  sections = {
    {
      pane = 2,
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      {
        align = "center",
        text = {
          { "⚡ Neovim loaded ", hl = "NvDashFooter" },

          { lazy_stats.loaded .. "/" .. lazy_stats.count, hl = "NvDashFooter" },
          { " plugins in ", hl = "NvDashFooter" },
          { ms .. "ms", hl = "NvDashFooter" },
        },
      },
    },
    {
      render = function(_, pos) end,
    },
    -- {
    --   section = "terminal",
    --   -- cmd = "chafa '" .. GetDashImage() .. "' --symbols vhalf --size 60x25 --stretch; sleep .1",
    --   cmd = { "chafa", GetDashImage(), "--size", "60x25", "--stretch", "-t", ".01", "--symbols", "vhalf" },
    --   height = 25,
    --   padding = 1,
    -- },
  },
}
return cfg
