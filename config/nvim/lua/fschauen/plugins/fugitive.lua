local M = { 'tpope/vim-fugitive' }

M.cmd = {
  'G',
  'Git',
}

M.keys = {
  { '<leader>gS', '<cmd>tab Git<cr>', desc = ' [S]status with fugitive' },
  { '<leader>gb', '<cmd>Git blame<cr>', desc = ' [b]lame' }
}

return M

