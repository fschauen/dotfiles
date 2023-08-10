return {
  'folke/todo-comments.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  keys = require('fschauen.keymap').todo_comments,
  event = {
    'BufReadPost',
    'BufNewFile'
  },
  opts = {
    keywords = {
      TODO = { icon = '󰄬 ' },
      FIX  = { icon = ' ' },
      HACK = { icon = ' ' },
      WARN = { icon = ' ' },
      PERF = { icon = '󰓅 ' },
      NOTE = { icon = '' },
      TEST = { icon = '󰙨 ' },
    },
  },
}

