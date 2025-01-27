return {
  -- {
  --   enabled = false,
  --   "lewis6991/gitsigns.nvim",
  -- },
  {
    "akinsho/git-conflict.nvim",
    event = "FileReadPost",
  },
  {
    "nvzone/timerly",
    dependencies = {

      "nvzone/volt",
    },
    cmd = "TimerlyToggle",
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        enabled = false,
      },
    },
    event = "VeryLazy",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      --refer to the configuration section below
    },
  },
  -- {
  --   "a-usr/nvchad_ui",
  --   name = "ui",
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, opts)
      opts.hijack_netrw = true
      opts.disable_netrw = false
      return opts
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = { winbar = true },
    },
  },
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  {
    "tris203/precognition.nvim",
    event = "BufReadPost",
    opts = {
      startVisible = true,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
      -- disabled_fts = {
      --     "startify",
      -- },
    },
  },
  {
    "a-usr/nui.nvim",
    name = "nui.nvim",
  },
  {
    -- enabled = false,
    "luukvbaal/statuscol.nvim",
    event = "BufEnter",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        --   -- configuration goes here, for example:
        --   -- relculright = true,
        segments = {
          { sign = { namespace = { "gitsigns_signs_.*" }, colwidth = 1, maxwidth = 2, auto = true } },
          {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
          {
            sign = { name = { "todo%-sign%-.*" }, auto = true, maxwidth = 2 },
            click = "v:lua.ScSa",
          },
          {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
            click = "v:lua.ScSa",
          },
          { sign = { name = { "Dap.*" }, auto = true }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          {
            sign = { namespace = { ".*" }, name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa",
          },
        },

        clickhandlers = {
          ---@param args (table): {
          ---   minwid = minwid,            -- 1st argument to 'statuscolumn' %@ callback
          ---   clicks = clicks,            -- 2nd argument to 'statuscolumn' %@ callback
          ---   button = button,            -- 3rd argument to 'statuscolumn' %@ callback
          ---   mods = mods,                -- 4th argument to 'statuscolumn' %@ callback
          ---   mousepos = f.getmousepos()  -- getmousepos() table, containing clicked line number/window id etc.
          --- }
          ["todo%-sign%-.*"] = function(args)
            print "a"
            print(vim.inspect(args))
            if args.button == "l" then
              vim.cmd "Trouble todo"
            end
          end,
        },
      }
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = function()
      local opts = {
        ---@module "edgy"
        ---@type (Edgy.View.Opts|string)[]
        left = {},
        ---@type (Edgy.View.Opts|string)[]
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            -- dont exclude floating windows :)
            filter = function(buf, win)
              local wincfg = vim.api.nvim_win_get_config(win)
              return wincfg.relative ~= "" or wincfg.split == "below"
            end,
          },
          -- {
          --   ft = "NvTerm_sp",
          --   size = { height = 0.4 },
          -- },

          { ft = "qf", title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- only show help buffers
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          {
            ft = "markdown", -- that exists, if it bothers you complain to lspconfig
            size = { height = 20 },
            -- only show help buffers
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
        },
        ---@type (Edgy.View.Opts|string)[]
        ---@type (Edgy.View.Opts|string)[]
        top = {},

        ---@type table<Edgy.Pos, {size:(integer | fun():integer), wo?:vim.wo}>
        options = {
          left = { size = 30 },
          bottom = { size = 10 },
          right = { size = 30 },
          top = { size = 10 },
        },
        -- edgebar animations
        animate = {
          enabled = true,
          fps = 100, -- frames per second
          cps = 1200, -- cells per second
          on_begin = function()
            vim.g.minianimate_disable = true
          end,
          on_end = function()
            vim.g.minianimate_disable = false
          end,
          -- Spinner for pinned views that are loading.
          -- if you have noice.nvim installed, you can use any spinner from it, like:
          -- spinner = require("noice.util.spinners").spinners.circleFull,
          spinner = {
            frames = { " ⠋", " ⠙", " ⠹", " ⠸", " ⠼", " ⠴", " ⠦", " ⠧", " ⠇", " ⠏" },
            interval = 80,
          },
        },
        -- enable this to exit Neovim when only edgy windows are left
        exit_when_last = true,
        -- close edgy when all windows are hidden instead of opening one of them
        -- disable to always keep at least one edgy split visible in each open section
        close_when_all_hidden = true,
        -- global window options for edgebar windows
        ---@type vim.wo
        wo = {
          -- Setting to `true`, will add an edgy winbar.
          -- Setting to `false`, won't set any winbar.
          -- Setting to a string, will set the winbar to that string.
          winbar = true,
          winfixwidth = true,
          winfixheight = false,
          winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
          spell = false,
          signcolumn = "no",
        },
        -- buffer-local keymaps to be added to edgebar buffers.
        -- Existing buffer-local keymaps will never be overridden.
        -- Set to false to disable a builtin.
        ---@type table<string, fun(win:Edgy.Window)|false>
        keys = {
          -- close window
          ["q"] = function(win)
            win:close()
          end,
          -- hide window
          ["<c-q>"] = function(win)
            win:hide()
          end,
          -- close sidebar
          ["Q"] = function(win)
            win.view.edgebar:close()
          end,
          -- next open window
          ["]w"] = function(win)
            win:next { visible = true, focus = true }
          end,
          -- previous open window
          ["[w"] = function(win)
            win:prev { visible = true, focus = true }
          end,
          -- next loaded window
          ["]W"] = function(win)
            win:next { pinned = false, focus = true }
          end,
          -- prev loaded window
          ["[W"] = function(win)
            win:prev { pinned = false, focus = true }
          end,
          -- increase width
          ["<c-w>>"] = function(win)
            win:resize("width", 2)
          end,
          -- decrease width
          ["<c-w><lt>"] = function(win)
            win:resize("width", -2)
          end,
          -- increase height
          ["<c-w>+"] = function(win)
            win:resize("height", 2)
          end,
          -- decrease height
          ["<c-w>-"] = function(win)
            win:resize("height", -2)
          end,
          -- reset all custom sizing
          ["<c-w>="] = function(win)
            win.view.edgebar:equalize()
          end,
        },
        icons = {
          closed = "  ",
          open = "  ",
        },
        -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
        -- Not needed on a nightly build >= June 5, 2023.
        fix_win_height = vim.fn.has "nvim-0.10.0" == 0,
      }
      -- trouble
      for _, pos in ipairs { "top", "bottom", "left", "right" } do
        opts[pos] = opts[pos] or {}
        table.insert(opts[pos], {
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.position == pos
              and vim.w[win].trouble.type == "split"
              and vim.w[win].trouble.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        })
      end
      return opts
    end,
  },
  {
    -- enabled = false,
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "BufReadPost",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
} ---@type LazySpec
