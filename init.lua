vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- use the experimental loader
vim.loader.enable()

-- Profiler
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup {
    startup = {
      -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      event = "VeryLazy",
    },
  }
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "git")

require "options"
require "nvchad.autocmds"
require "autocmds"
require "signs"
require "highlights"
vim.env.EDITOR = "nvr --remote-wait-silent -l "

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if syntax == "markdown" then
    vim.bo[bufnr].syntax = "lsp_markdown"
    vim.wo[winnr].linebreak = true
    vim.wo[winnr].signcolumn = "no"
    vim.wo[winnr].conceallevel = 3
    require("markview").render(bufnr, { enable = true, hybrid_mode = false })
  end
  return bufnr, winnr
end

vim.schedule(function()
  require "mappings"
end)
