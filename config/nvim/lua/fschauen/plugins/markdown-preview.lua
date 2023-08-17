local M = { 'iamcco/markdown-preview.nvim' }

M.build = 'cd app && npm install'

M.init = function(_)
  vim.g.mkdp_theme = 'dark'
end

M.event = {
  'FileType markdown',
}

return M

