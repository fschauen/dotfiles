local M = { '2kabhishek/nerdy.nvim' }

M.cmd = 'Nerdy'

M.dependencies = {
  'stevearc/dressing.nvim',
  'nvim-telescope/telescope.nvim',
}

M.keys = {
  { '<leader>fi', '<cmd>Nerdy<cr>', desc = ' Telescope Nerd [i]cons' },
}

return M

