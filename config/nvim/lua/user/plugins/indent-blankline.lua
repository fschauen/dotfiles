return {
  'lukas-reineke/indent-blankline.nvim',

  opts = {
    enabled = false,
  },

  config = function(_, opts)
    require('indent_blankline').setup(opts)

    -- show/hide indent guides
    vim.keymap.set('n', '<leader>si', '<cmd>IndentBlanklineToggle<cr>')
  end,
}

