return {
  'folke/trouble.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  keys = require('fschauen.keymap').trouble,
  opts = {
    padding = false,      -- don't add an extra new line of top of the list
    auto_preview = false, -- don't preview automatically
  },
}
