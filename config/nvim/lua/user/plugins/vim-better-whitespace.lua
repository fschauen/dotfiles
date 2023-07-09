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
    -- fix whitespace
    vim.keymap.set('n', '<leader>dw', '<cmd>StripWhitespace<cr>')

    -- show/hide whitespace
    vim.keymap.set('n', '<leader>tw', '<cmd>ToggleWhitespace<cr>')
  end,
}

