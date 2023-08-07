local telescope = vim.F.npcall(require, 'fschauen.plugins.telescope')
local trigger = telescope and telescope.trigger or '<leader>f'

return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = true,
  event = { 'BufReadPost', 'BufNewFile' },
  keys = {
    { trigger .. 't', '<cmd>TodoTelescope<cr>' },
  },
}

