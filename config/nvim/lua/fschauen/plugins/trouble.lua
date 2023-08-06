return {
  'folke/trouble.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    local trouble = require('trouble')

    trouble.setup {
      padding = false,  -- don't add an extra new line of top of the list
      auto_preview = false,  -- don't preview automatically
    }

    vim.keymap.set('n', '<leader>lt', '<cmd>TroubleToggle<cr>')
    vim.keymap.set('n', '<leader>lw', '<cmd>TroubleToggle workspace_diagnostics<cr>')
    vim.keymap.set('n', '<leader>ld', '<cmd>TroubleToggle document_diagnostics<cr>')
  end
}

