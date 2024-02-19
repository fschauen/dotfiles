local M = { 'folke/todo-comments.nvim' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
}

M.event = { 'BufReadPost', 'BufNewFile' }

local ts = require('fschauen.plugins.telescope')
local lhs, desc = ts.keymap.lhs, ts.keymap.description

M.keys = {
  { lhs('t'), '<cmd>TodoTelescope<cr>', desc = desc('[t]odos') },
}

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.util.icons')
  return vim.tbl_deep_extend('force', opts or {}, {
    keywords = {
      TODO = { icon = icons.ui.Checkbox },
      FIX  = { icon = icons.ui.Bug },
      HACK = { icon = icons.ui.Fire },
      WARN = { icon = icons.ui.Warning },
      PERF = { icon = icons.ui.Gauge },
      NOTE = { icon = icons.ui.Note },
      TEST = { icon = icons.ui.TestTube },
    },
    gui_style = { fg = 'bold' },
    highlight = {
      multiline = false,
      before = 'fg',
      keyword = 'wide_fg',
      after = '',
    }
  })
end

return M

