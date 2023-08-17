local M = { 'lukas-reineke/virt-column.nvim' }

M.event = {
  'BufReadPost',
  'BufNewFile'
}

local toggle_colorcolumn = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'  -- one after 'textwidth'
  else
    vim.o.colorcolumn = ''    -- none
  end
end

M.keys = {
  { '<leader>sc', toggle_colorcolumn, desc = 'Toggle virtual colunn' },
}

M.opts = {
  char = '│',
}

return M

