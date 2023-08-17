local M = { 'folke/trouble.nvim' }

M.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

M.keys = require('fschauen.keymap').trouble

M.opts = {
  padding = false,      -- don't add an extra new line of top of the list
  auto_preview = false, -- don't preview automatically
}

return M

