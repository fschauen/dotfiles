local M = { 'lukas-reineke/indent-blankline.nvim' }

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

M.main = 'ibl'

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.icons')
  return vim.tbl_deep_extend('force', opts, {
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
  })
end

return M
