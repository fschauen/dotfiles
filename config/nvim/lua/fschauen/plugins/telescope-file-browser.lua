local M = { 'nvim-telescope/telescope-file-browser.nvim' }

M.dependencies = {
  'nvim-telescope/telescope.nvim',
}

M.keys = {
  { '<leader>fB', '<cmd>Telescope file_browser<cr>' , desc = ' Telescope file [B]rowser' },
}

M.config = function()
  require('telescope').load_extension('file_browser')
end

return M

