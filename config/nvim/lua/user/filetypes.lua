vim.filetype.add {
  pattern = {
    ['${HOME}/.ssh/config.d/.*'] = 'sshconfig',
    ['.*/ssh/config'] = 'sshconfig',
    ['.*/git/config'] = 'gitconfig',
  }
}

