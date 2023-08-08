return {
  'lukas-reineke/virt-column.nvim',

  opts = {
    char = '│',
  },

  event = { 'BufReadPost', 'BufNewFile' },

  keys ={
    {
      '<leader>sc',
      function()
        if vim.o.colorcolumn == '' then
          vim.o.colorcolumn = '+1'  -- one after 'textwidth'
        else
          vim.o.colorcolumn = ''    -- none
        end
      end,
      'Toggle virtual colunn'
    },
  },
}

