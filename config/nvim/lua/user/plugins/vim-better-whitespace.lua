return {
  'ntpeters/vim-better-whitespace',

  init = function()
    vim.g.better_whitespace_filetypes_blacklist = {
      'diff',
      'fugitive',
      'git',
      'gitcommit',
      'help',
    }
  end,

  config = function()
    vim.keymap.set('n', '<leader>ww', '<cmd>ToggleWhitespace<cr>')
    vim.keymap.set('n', '<leader>wn', '<cmd>NextTrailingWhitespace<cr>')
    vim.keymap.set('n', '<leader>wp', '<cmd>PrevTrailingWhitespace<cr>')
    vim.keymap.set('n', '<leader>W', '<cmd>StripWhitespace<cr>')
  end,
}

