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
    --- Picker ---
    {
      "f",
      group = "Find",
      icon = " ",
      {
        "f",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      {
        "a",
        function()
          Snacks.picker.files { hidden = true, ignored = true }
        end,
        desc = "Find all files",
      },
      {
        "w",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live grep",
      },
      {
        "b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find buffers",
      },
      {
        "h",
        function()
          Snacks.picker.help()
        end,
        desc = "Help page",
      },
      {
        "z",
        function()
          Snacks.picker.lines()
        end,
        desc = "search in current buffer",
      },
      {
        "g",
        group = "git",
        {
          "c",
          function()
            Snacks.picker.git_log()
          end,
          desc = "git Log",
        },
        {
          "s",
          function()
            Snacks.picker.git_status()
          end,
          desc = "git Status",
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
    --- Persisted ---
    {
      "<TAB>",
      group = "Session",
      {
        "l",
        function()
          -- require("snacks").picker.projects()
          Snacks.picker.pick {
            items = require("session_finder").find(),
            format = require("session_finder").format,
            confirm = function(picker, item)
              picker:close()
              require("persisted").load { session = item.session }
            end,
          }
        end,
        desc = "Load Session",
      },
      {
        "r",
        function()
          require("persisted").load { last = true }
        end,
        desc = "Restore Session",
      },
    },
  },
  --- FileTree ---
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
        "<A-i>",
        function()
          require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
        end,
        desc = "terminal toggle floating term",
      },
      --- Toggle edgy ---
      {
        "<A-v>",
        function()
          require("edgy").toggle "right"
        end,
        desc = "window toggleable vertical bar",
      },
      {
        "<A-h>",
        function()
          require("edgy").toggle "bottom"
        end,
        desc = "window toggleable horizontal bar",
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
        "b",
        group = "buffer/breakpoint", -- atm this group is also occupied by breakpoint binds declared in dap.lua
        {
          "x",
          function()
            require("nvchad.tabufline").close_buffer()
          end,
          desc = "buffer close",
        },
        {
          "n",
          "<cmd>enew<CR>",
          desc = "buffer new",
        },
      },
    },
  },
  {
    "<C-p>",
    function()
      local ui_select = vim.ui.select
      vim.ui.select = require("vscodeselect").select
      require("toolbox").show_picker()
      vim.ui.select = ui_select
    end,
    desc = "Show Command Pallete",
  },
}
