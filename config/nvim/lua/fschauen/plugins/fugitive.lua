return {
  'tpope/vim-fugitive',

  config = function()
    vim.keymap.set('n', '<leader>gg', ':Git ')
    vim.keymap.set('n', '<leader>gs', '<cmd>tab Git<cr>')
    vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>')
  end,
}

