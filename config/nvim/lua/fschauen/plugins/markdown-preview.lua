return {
  'iamcco/markdown-preview.nvim',
  build = 'cd app && npm install',
  init = function(_)
    vim.g.mkdp_theme = 'dark'
  end,
  event = {
    'FileType markdown',
  },
}
