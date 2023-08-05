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
          o = 'Toggle',
        },
      },
    }

    vim.keymap.set('n', '<leader>ng', '<cmd>Neogit<cr>')
  end,
}

