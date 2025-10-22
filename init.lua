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
local language_plugins = require "languages"

local all_plugins = vim
  .iter({
    {
      { import = "plugins" },
    },
    language_plugins,
  })
  :flatten()
  :totable()

-- load plugins
require("lazy").setup(all_plugins, lazy_config)

require "options"
require "settings"
require "autocmds"
require "signs"
require "highlights"
require "configs.lsp"

vim.schedule(function()
  require "mappings"
end)
