local M = { 'lukas-reineke/indent-blankline.nvim' }

local icons = require('fschauen.icons')

M.config = function()
  require('ibl').setup {
    enabled = false,
    indent = {
      char = icons.ui.LineLeft,
    },
    scope = {
      char = icons.ui.LineLeftBold,
      enabled = false,
      show_start = false,
      show_end = false,
    },
  }
end

M.cmd = {
  'IBLEnable',
  'IBLDisable',
  'IBLToggle',
  'IBLEnableScope',
  'IBLDisableScope',
  'IBLToggleScope',
}

M.keys = {
  { '<leader>si', '<cmd>IBLToggle<cr>' },
  { '<leader>so', '<cmd>IBLToggleScope<cr>' },
}

return M
