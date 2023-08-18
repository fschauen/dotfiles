local M = { 'mawkler/modicator.nvim' }

M.event = {
  'ColorScheme',
  'ModeChanged',
}

M.config = function()
  require('modicator').setup()
end

return M

