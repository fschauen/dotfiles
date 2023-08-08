return {
  'NeogitOrg/neogit',

  opts = {
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
  },

  keys = {
    { '<leader>gn', '<cmd>Neogit<cr>' },
  },
}
