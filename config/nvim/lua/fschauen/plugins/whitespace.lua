local M = { 'ntpeters/vim-better-whitespace' }

M.init = function()
  vim.g.better_whitespace_filetypes_blacklist = {
    'diff',
    'fugitive',
    'git',
    'gitcommit',
    'help',
  }
end

M.keys = require('fschauen.keymap').whitespace

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.config = false

return M

