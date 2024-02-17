local M = { 'johmsalas/text-case.nvim' }

M.event = {
  'BufReadPost',
  'BufNewFile',
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  require('textcase').setup {
    prefix = '<leader>c',
  }
end

return M

