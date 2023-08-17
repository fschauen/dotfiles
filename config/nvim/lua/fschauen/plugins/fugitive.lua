local M = { 'tpope/vim-fugitive' }

M.cmd = {
  'G',
  'Git',
}

M.keys = require('fschauen.keymap').fugitive

return M

