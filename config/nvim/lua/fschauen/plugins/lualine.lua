return {
  'nvim-lualine/lualine.nvim',
  opts = function()
    return {
      options = {
        icons_enabled = true,
        component_separators = {
          left = '',
          right = ''
        },
        section_separators = {
          left = '',
          right = ''
        },
        theme = 'gruvbox',
      },
      sections = require('fschauen.lualine').sections.active,
      inactive_sections = require('fschauen.lualine').sections.inactive,
      extensions = {
        'fugitive',
        'quickfix',
        'nvim-tree',
        'lazy',
        'man',
        'trouble',
      },
    }
  end
}

