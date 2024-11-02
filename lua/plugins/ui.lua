return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = { winbar = true },
    },
  },
  {
    "a-usr/base46",
    name = "base46",
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
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").load_extension "ui-select"
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
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require "notify"
    end,
  },
  {
    "a-usr/nui.nvim",
    name = "nui.nvim",
  },
  {
    -- enabled = false,
    "luukvbaal/statuscol.nvim",
    event = "BufEnter",
    config = function(_, opts)
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        --   -- configuration goes here, for example:
        --   -- relculright = true,
        segments = {
          { sign = { namespace = { "gitsigns_signs_.*" }, colwidth = 1, maxwidth = 2, auto = true } },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          { sign = { name = { "Dap.*" }, auto = true }, click = "v:lua.ScSa" },
          {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          {
            sign = { namespace = { ".*" }, name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa",
          },
        },
      }
    end,
  },
} ---@type LazySpec
