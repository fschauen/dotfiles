vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require 'fschauen.disable_builtin'
require 'fschauen.globals'
require 'fschauen.options'
require 'fschauen.keymap'
require 'fschauen.autocmds'
require 'fschauen.filetypes'
require 'fschauen.diagnostics'
require 'fschauen.lazy'

require('fschauen.util').set_colorscheme('gruvbox')

