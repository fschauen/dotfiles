local M = { 'iamcco/markdown-preview.nvim' }

M.build = function()
  vim.fn["mkdp#util#install"]()
end

M.cmd = {
  'MarkdownPreview',
  'MarkdownPreviewStop',
  'MarkdownPreviewToggle',
}

M.ft = {
  'markdown',
}

M.init = function(--[[plugin]]__)
  vim.g.mkdp_theme = 'dark'
end

return M

