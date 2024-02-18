local M = { 'ntpeters/vim-better-whitespace' }

M.init = function(--[[plugin]]_)
  vim.g.better_whitespace_filetypes_blacklist = {
    'diff',
    'fugitive',
    'git',
    'gitcommit',
    'help',
  }
end

M.event = { 'BufReadPost', 'BufNewFile' }

M.keys = {
  { '<leader>ww', '<cmd>ToggleWhitespace<cr>' },
  { '<leader>wj', '<cmd>NextTrailingWhitespace<cr>' },
  { '<leader>wk', '<cmd>PrevTrailingWhitespace<cr>' },
  { '<leader>W',  '<cmd>StripWhitespace<cr>' },
}

return M

