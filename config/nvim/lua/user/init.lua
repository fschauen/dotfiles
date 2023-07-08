vim.g.mapleader = ' '

require 'user.disable_builtin'
require 'user.globals'
require 'user.options'
require 'user.keymaps'
require 'user.autocmds'
require 'user.filetypes'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'user.plugins'

