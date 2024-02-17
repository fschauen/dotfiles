local M = { 'NeogitOrg/neogit' }

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.keys = {
  { '<leader>gs', '<cmd>Neogit<cr>', desc = ' [s]tatus with neogit' },
}

M.config = function(--[[plugin]]_, --[[opts]]_)
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

