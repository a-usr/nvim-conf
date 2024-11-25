local a = require "plenary.async"
local lazy_stats = require("lazy.stats").stats()
local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
local dashboard = require "snacks.dashboard"

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
    if #files then
      img = files[math.random(#files)]
      imgloaded = true
    else
      imgloaded = "never"
    end
  end)
end
GetDashImage()
function dashboard.sections.sixelimg()
  local width = 60
  local height = 25
  return function(self)
    while not imgloaded do
      vim.uv.sleep(1)
    end
    local cmd
    if imgloaded ~= "never" then
      cmd = { "chafa", img, "--format", "sixels", "—-size", "60x25" }
    else
      cmd = {}
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local function send(data)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
    end
    vim.fn.jobstart(cmd, {
      height = height,
      width = width,
      pty = true,
      on_stdout = function(_, data)
        pcall(send, data)
      end,
    })
    return {
      render = function(_, pos)
        local win = vim.api.nvim_open_win(buf, false, {
          bufpos = { pos[1] - 1, pos[2] + 1 },
          col = 0,
          focusable = false,
          height = height,
          noautocmd = true,
          relative = "win",
          row = 0,
          zindex = Snacks.config.styles.dashboard.zindex + 1,
          style = "minimal",
          width = width,
          win = self.win,
        })
      end,
    }
  end
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
      -- section = "sixelimg",
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
