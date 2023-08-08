local prefix = require('fschauen.telescope').prefix or '<leader>f'

return {
  'folke/todo-comments.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = true,
  event = {
    'BufReadPost',
    'BufNewFile'
  },
  keys = {
    { prefix .. 't', '<cmd>TodoTelescope<cr>' },
  },
}

