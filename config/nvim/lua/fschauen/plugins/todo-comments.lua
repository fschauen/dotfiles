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
  { '<leader>ft', '<cmd>TodoTelescope<cr>', desc = ' Telescope [t]odos'  },
}

local icons = require('fschauen.icons')

M.config = function()
  require('todo-comments').setup {
    keywords = {
      TODO = { icon = icons.ui.Checkbox },
      FIX  = { icon = icons.ui.Bug },
      HACK = { icon = icons.ui.Fire },
      WARN = { icon = icons.ui.Warning },
      PERF = { icon = icons.ui.Gauge },
      NOTE = { icon = icons.ui.Note },
      TEST = { icon = icons.ui.TestTube },
    },
  }
end

return M

