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
  keys = require('fschauen.keymap').whitespace,
  event = {
    'BufReadPost',
    'BufNewFile'
  },
  config = false,
}

