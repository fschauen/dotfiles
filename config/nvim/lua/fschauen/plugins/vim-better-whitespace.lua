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

  config = false,

  keys ={
    { '<leader>ww', '<cmd>ToggleWhitespace<cr>' },
    { '<leader>wj', '<cmd>NextTrailingWhitespace<cr>' },
    { '<leader>wk', '<cmd>PrevTrailingWhitespace<cr>' },
    { '<leader>wd', '<cmd>StripWhitespace<cr>' },
  },
}

