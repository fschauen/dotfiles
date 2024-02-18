local M = { '2kabhishek/nerdy.nvim' }

M.cmd = 'Nerdy'

M.dependencies = {
  'stevearc/dressing.nvim',
  'nvim-telescope/telescope.nvim',
}

local ts = require('fschauen.plugins.telescope')
local lhs, desc = ts.keymap.lhs, ts.keymap.description

M.keys = {
  { lhs('i'), '<cmd>Nerdy<cr>', desc = desc('Nerd [i]cons') },
}

return M

