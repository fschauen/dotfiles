return {
  'NeogitOrg/neogit',

  config = function()
    require('neogit').setup {
      disable_hint = true,
      signs = {
        section = { '', ''},
        item    = { '', ''},
        hunk    = { '', ''},
      },
      mappings = {
        status = {
          o = 'GoToFile',
          ['<space>'] = 'Toggle',
        },
      },
    }

    vim.keymap.set('n', '<leader>gn', '<cmd>Neogit<cr>')
  end,
}

