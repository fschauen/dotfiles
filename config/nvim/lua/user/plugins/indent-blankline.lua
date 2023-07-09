return {
  'lukas-reineke/indent-blankline.nvim',

  config = function()
    require('indent_blankline').setup {
      enabled = false,
    }

    -- show/hide indent guides
    vim.keymap.set('n', '<leader>si', '<cmd>IndentBlanklineToggle<cr>')
  end,
}

