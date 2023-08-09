return {
  'NeogitOrg/neogit',
  keys = require('fschauen.keymap').neogit,
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
}
