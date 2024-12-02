local a = require "plenary.async"
local asyncUtil = require "plenary.async.util"
local lazy_stats = require("lazy.stats").stats()
local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
local dashboard = require "snacks.dashboard"

local imgdata, stat
local path = string.gsub(vim.fn.stdpath "cache", "([^A-Z][^:])\\", "%1/") .. "/dashimgs"
---@diagnostic disable-next-line

function dashboard.sections.sixelimg()
  local width = 60
  local height = 25
  a.run(
    asyncUtil.protected(function()
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
      if #files >= 1 then
        local img = path .. "/" .. files[math.random(#files)]
        local cmd = {
          "chafa",
          img,
          "--format",
          "sixels",
          "--size=" .. tostring(width) .. "x" .. tostring(height),
          "--align",
          "center,center",
          "--view-size=" .. tostring(width) .. "x" .. tostring(height),
        }
        local out, extrarow = a.wrap(vim.system, 2)(cmd).stdout:gsub("\r?\n", "")
        local extracol
        out, extracol = out:gsub(" ", "")
        return { out, extrarow, extracol }
      else
        print "aaaa"
        return { "", 0, 0 }
      end
    end),
    function(stat_, ...)
      stat = stat_
      imgdata = ...
    end
  )
  return function(self)
    vim.wait(2000, function()
      return stat ~= nil
    end, 20, false)
    local out, extrarow, extracol
    if stat then
      out, extrarow, extracol = unpack(imgdata)
    else
      Snacks.debug.log "async task failed or timed out"
      out, extrarow, extracol = "", 0, 0
    end
    local buf = vim.api.nvim_create_buf(false, true)
    local pos = {}
    local augroup = vim.api.nvim_create_augroup("snacks.dashboard.sixelimg", {})
    return {
      render = function(_, _pos)
        pos = _pos
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
        local row, col = unpack(pos)
        local function display()
          -- vim.cmd "redraw!"
          vim.cmd "redraw"
          vim.schedule(function()
            -- vim.cmd "redraw"
            -- vim.cmd "redraw!"
            vim.fn.chansend(
              vim.v.stderr,
              -- save cursor, move cursor to target, display sixel, restore cursor
              "\27[s"
                .. string.format("\27[%d;%dH", row + (extrarow > 1 and extrarow or 0), col + extracol + 2)
                .. out
                .. "\27[u"
            )
          end)
        end
        display()
        vim.schedule(function()
          vim.api.nvim_create_autocmd("WinScrolled", {
            group = augroup,
            pattern = "*",
            callback = function()
              vim.schedule(display)
            end,
          })
        end)
        local close = vim.schedule_wrap(function()
          vim.api.nvim_clear_autocmds {
            group = augroup,
          }
          pcall(vim.api.nvim_win_close, win, true)
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
          vim.wait(100, function()
            vim.cmd "mode"
            return false
          end)
          return true
        end)
        self.on("UpdatePre", close)
        self.on("Closed", close)
        self:trace()
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
      section = "sixelimg",
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
