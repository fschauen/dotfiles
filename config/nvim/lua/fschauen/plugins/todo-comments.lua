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
    { '<leader>ft', '<cmd>TodoTelescope<cr>' },
  },
}

