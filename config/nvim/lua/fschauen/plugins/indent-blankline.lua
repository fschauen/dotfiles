local M = { 'lukas-reineke/indent-blankline.nvim' }

M.cmd = {
  'IBLEnable',
  'IBLDisable',
  'IBLToggle',
  'IBLEnableScope',
  'IBLDisableScope',
  'IBLToggleScope',
}

local toggle = require('fschauen.util.icons').ui.Toggle .. '  toggle '

M.keys = {
  { '<leader>si', '<cmd>IBLToggle<cr>', desc = toggle .. 'indent lines' },
  { '<leader>so', '<cmd>IBLToggleScope<cr>', desc = toggle .. 'indent line scope' },
}

M.main = 'ibl'

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.util.icons')
  return vim.tbl_deep_extend('force', opts or {}, {
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
