return {
  'lukas-reineke/indent-blankline.nvim',

  lazy = false,  -- trows an error when lazy loading

  config = function()
    require('indent_blankline').setup {
      enabled = false,
    }

    -- show/hide indent guides
    vim.keymap.set('n', '<leader>si', '<cmd>IndentBlanklineToggle<cr>')
  end,
}

