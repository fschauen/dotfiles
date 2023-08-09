vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require 'fschauen.setup.globals'
require 'fschauen.setup.options'
require('fschauen.keymap').setup()
require 'fschauen.setup.autocmd'
require 'fschauen.setup.filetype'
require 'fschauen.setup.diagnostic'
require 'fschauen.setup.lazy'

require('fschauen').colorscheme('gruvbox')

