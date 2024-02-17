local M = { 'stevearc/oil.nvim' }

M.cmd = 'Oil'

M.dependencies = { 'nvim-tree/nvim-web-devicons' }

M.keys = {
  { '<leader>o', '<cmd>Oil<cr>' },
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  require('oil').setup {
    default_file_explorer = true,

    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },

    constrain_cursor = 'name',

    keymaps = {
      -- Not using <c-v> because Visual Block mode is useful in an Oil buffer.
      ['<C-l>'] = 'actions.select_vsplit',

      ['<C-j>'] = 'actions.select_split',
      ['<C-s>'] = 'actions.select_split',
      ['<C-h>'] = false,  -- Disable default keymap for 'actions.select_split'.

      ['<C-r>'] = 'actions.refresh',

      ['q'] = 'actions.close',
    },

    view_options = {
      show_hidden = true,
    },
  }
end

return M

