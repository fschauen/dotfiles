local M = { 'folke/todo-comments.nvim' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
}

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.keys = {
  { '<leader>ft', '<cmd>TodoTelescope<cr>' },
}

M.config = function()
  require('todo-comments').setup {
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
end

return M

