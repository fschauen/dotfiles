local M = { 'folke/todo-comments.nvim' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
}

M.event = { 'BufReadPost', 'BufNewFile' }

M.keys = {
  { '<leader>ft', '<cmd>TodoTelescope<cr>', desc = ' Telescope [t]odos'  },
}

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.icons')
  return vim.tbl_deep_extend('force', opts, {
    keywords = {
      TODO = { icon = icons.ui.Checkbox },
      FIX  = { icon = icons.ui.Bug },
      HACK = { icon = icons.ui.Fire },
      WARN = { icon = icons.ui.Warning },
      PERF = { icon = icons.ui.Gauge },
      NOTE = { icon = icons.ui.Note },
      TEST = { icon = icons.ui.TestTube },
    },
  })
end

return M

