return {
  'lukas-reineke/virt-column.nvim',
  event = {
    'BufReadPost',
    'BufNewFile'
  },
  keys = require('fschauen.keymap').virt_column,
  opts = {
    char = '│',
  },
}

