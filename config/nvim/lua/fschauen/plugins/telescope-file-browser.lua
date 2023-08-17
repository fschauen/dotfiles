local M = { 'nvim-telescope/telescope-file-browser.nvim' }

M.dependencies = {
  'nvim-telescope/telescope.nvim',
}

M.keys = require('fschauen.keymap').telescope_file_browser

M.config = function()
  require('telescope').load_extension 'file_browser'
end

return M

