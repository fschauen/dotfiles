local M = { 'johmsalas/text-case.nvim' }

M.event = {
  'BufReadPost',
  'BufNewFile',
}

M.config = function()
  require('textcase').setup {
    prefix = '<leader>c',
  }
end

return M

