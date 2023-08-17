local M = { 'NeogitOrg/neogit' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.keys = {
  { '<leader>gn', '<cmd>Neogit<cr>' },
}

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
      ['='] = 'Toggle',
    },
  },
}

return M

