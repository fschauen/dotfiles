return {
  'folke/trouble.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    local trouble = require('trouble')

    trouble.setup {
      padding = false,  -- don't add an extra new line of top of the list
      auto_preview = false,  -- don't preview automatically
    }

    vim.keymap.set('n', '<leader>xx', function() trouble.open() end)
    vim.keymap.set('n', '<leader>xw', function() trouble.open('workspace_diagnostics') end)
    vim.keymap.set('n', '<leader>xd', function() trouble.open('document_diagnostics') end)
  end
}

