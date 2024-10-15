return require("mappings.util").Map {
  {
    "<leader>",
    { ---@type mapping.proto
      "t",
      {
        "t",
        function()
          require("base46").toggle_transparency()
        end,
        desc = "Toggle Transparency",
      },
      {
        "h",
        function()
          require("nvchad.themes").open()
        end,
        desc = "nvchad themes",
      },
    },
    {
      "fm",
      function()
        require("conform").format { lsp_fallback = true }
      end,
      desc = "General Format file",
    },
    --- Telescope ---
    {
      "f",
      group = "telescope",
      {
        "f",
        "<cmd>Telescope find_files<cr>",
        desc = "telescope find files",
      },
      {
        "a",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        desc = "telescope find all files",
      },
      {
        "w",
        "<cmd>Telescope live_grep<CR>",
        desc = "telescope live grep",
      },
      {
        "b",
        "<cmd>Telescope buffers<CR>",
        desc = "telescope find buffers",
      },
      {
        "h",
        "<cmd>Telescope help_tags<CR>",
        desc = "telescope help page",
      },
      {
        "o",
        "<cmd>Telescope oldfiles<CR>",
        desc = "telescope find oldfiles",
      },
      {
        "z",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        desc = "telescope find in current buffer",
      },
      {
        "g",
        group = "git",
        {
          "c",
          "<cmd>Telescope git_commits<CR>",
          desc = "telescope git commits",
        },
        {
          "s",
          "<cmd>Telescope git_status<CR>",
          desc = "telescope git status",
        },
      },
    },
    --- Comments ---
    {
      "/",
      remap = true,
      {
        "",
        "gcc",
        mode = "n",
        desc = "Toggle Comment",
      },
      {
        "",
        "gc",
        mode = "v",
        desc = "Toggle Comment",
      },
    },
    --- Persistence ---
    {
      "<TAB>",
      group = "Session",
      {
        "l",
        function()
          require("persistence").select()
        end,
        desc = "Load Session",
      },
      {
        "r",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore Session",
      },
    },
  },
  --- NeoTree ---
  {
    {
      "<leader>e",
      "<cmd>NvimTreeFocus<CR>",
      -- function()
      --   local reveal_file = vim.fn.expand "%:p"
      --   if reveal_file == "" then
      --     reveal_file = vim.fn.getcwd()
      --   else
      --     local f = io.open(reveal_file, "r")
      --     if f then
      --       f.close(f)
      --     else
      --       reveal_file = vim.fn.getcwd()
      --     end
      --   end
      --   require("neo-tree.command").execute {
      --     action = "focus", -- OPTIONAL, this is the default value
      --     source = "filesystem", -- OPTIONAL, this is the default value
      --     position = "left", -- OPTIONAL, this is the default value
      --     reveal_file = reveal_file, -- path to file or folder to reveal
      --     reveal_force_cwd = false, -- change cwd without asking if needed
      --   }
      -- end,
      desc = "FileTree Focus",
    },
    {
      "<C-n>",
      -- function()
      --   require("neo-tree.command").execute {
      --     toggle = true,
      --   }
      -- end,
      "<cmd>NvimTreeToggle<CR>",
      desc = "FileTree Toggle",
    },
  },

  --- Toggle terms ---
  {
    {
      mode = { "n", "t" },
      {
        "<A-v>",
        function()
          require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
        end,
        desc = "terminal toggleable vertical term",
      },
      {
        "<A-h>",
        function()
          require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
        end,
        desc = "terminal toggleable horizontal term",
      },
      {
        "<A-i>",
        function()
          require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
        end,
        desc = "terminal toggle floating term",
      },
    },
    {
      "<C-x",
      "<C-\\><C-N>",
      desc = "terminal escape terminal mode",
      mode = "t",
    },
  },

  {
    "<RightMouse>",
    function()
      vim.cmd.exec '"normal! \\<RightMouse>"'

      local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
      require("menu").open(options, { mouse = true })
    end,
  },
  {
    "<ESC>",
    "<cmd>noh<CR>",
    desc = "General Clear Highlights",
  },
  {
    "<C-s>",
    "<cmd>w<CR>",
    desc = "general Save File",
  },
  --- tabufline ---
  {
    {
      "<Tab>",
      function()
        require("nvchad.tabufline").next()
      end,
      desc = "buffer goto next",
    },
    {
      "<S-Tab>",
      function()
        require("nvchad.tabufline").prev()
      end,
      desc = "buffer goto prev",
    },
    {
      "<leader>",
      {
        "x",
        function()
          require("nvchad.tabufline").close_buffer()
        end,
        desc = "buffer close",
      },
      {
        "b",
        "<cmd>enew<CR>",
        desc = "buffer new",
      },
    },
  },
}
