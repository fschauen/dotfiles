local M = { 'tpope/vim-fugitive' }

M.cmd = {
  'G',
  'Git',
}

M.keys = {
  { '<leader>gg', ':Git ' },
  { '<leader>gs', '<cmd>tab Git<cr>' },
  { '<leader>gb', '<cmd>Git blame<cr>' }
}

return M

