require('virt-column').setup {
  char = '│',
}

local toggle_virtual_column = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'  -- one after 'textwidth'
  else
    vim.o.colorcolumn = ''    -- none
  end
end

vim.keymap.set('n', '<leader>sc', toggle_virtual_column)

