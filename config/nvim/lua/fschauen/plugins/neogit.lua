local M = { 'NeogitOrg/neogit' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.keys = {
  { '<leader>gn', '<cmd>Neogit<cr>' },
}

M.config = function()
  local icons = require('fschauen.icons')

  require('neogit').setup {
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
  }
end

return M

