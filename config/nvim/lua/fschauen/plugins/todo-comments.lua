local M = { 'folke/todo-comments.nvim' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.keys = require('fschauen.keymap').todo_comments

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.opts = {
  keywords = {
    TODO = { icon = '󰄬 ' },
    FIX  = { icon = ' ' },
    HACK = { icon = ' ' },
    WARN = { icon = ' ' },
    PERF = { icon = '󰓅 ' },
    NOTE = { icon = '' },
    TEST = { icon = '󰙨 ' },
  },
}

return M

