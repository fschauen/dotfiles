local M = {}

M.setup = function()
  vim.filetype.add {
    pattern = {
      ['${HOME}/.ssh/config.d/.*'] = 'sshconfig',
      ['.*/ssh/config'] = 'sshconfig',
      ['.*/git/config'] = 'gitconfig',
      ['.*config/zsh/.*'] = 'zsh',
    }
  }
end

return M

