local M = { 'nvim-telescope/telescope-file-browser.nvim' }

M.dependencies = { 'nvim-telescope/telescope.nvim' }

local ts = require('fschauen.plugins.telescope')
local lhs, desc = ts.keymap.lhs, ts.keymap.description

M.keys = {
  { lhs('B'), '<cmd>Telescope file_browser<cr>' , desc = desc('file [B]rowser') },
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  require('telescope').load_extension('file_browser')
end

return M

