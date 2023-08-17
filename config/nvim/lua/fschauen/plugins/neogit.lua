local M = { 'NeogitOrg/neogit' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.keys = require('fschauen.keymap').neogit

M.opts = {
  disable_hint = true,
  signs = {
    section = { '', '' },
    item    = { '', '' },
    hunk    = { '', '' },
  },
  mappings = {
    status = {
      o = 'GoToFile',
      ['<space>'] = 'Toggle',
    },
  },
}

return M

