local M = { 'lukas-reineke/virt-column.nvim' }

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.keys = require('fschauen.keymap').virt_column

M.opts = {
  char = '│',
}

return M

