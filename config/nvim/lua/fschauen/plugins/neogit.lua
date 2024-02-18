local M = { 'NeogitOrg/neogit' }

M.cmd = 'Neogit'

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.keys = {
  { '<leader>gs', '<cmd>Neogit<cr>', desc = ' [s]tatus with neogit' },
}

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.util.icons')
  return vim.tbl_deep_extend('force', opts, {
    disable_hint = true,
    signs = {
      section = { icons.ui.Folder, icons.ui.EmptyFolderOpen },
      item    = { icons.ui.ChevronRight, icons.ui.ChevronDown },
      hunk    = { icons.ui.ChevronSmallRight, icons.ui.ChevronSmallDown },
    },
    mappings = {
      status = {
        o = 'GoToFile',
        ['='] = 'Toggle',
      },
    },
  })
end

return M

