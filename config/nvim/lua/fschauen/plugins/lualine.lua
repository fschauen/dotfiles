local orange = '#d65d0e'
local bright = '#ffffff'  -- alternative: '#f9f5d7'

return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local window = require 'fschauen.window'
    local colored_if_focused = require('fschauen.lualine').colored_if_focused

    -- custom components
    local C = {
      diagnostics = {
        colored_if_focused('diagnostics'),
      },
      diff = {
        colored_if_focused('diff'),
        symbols = {
          added = '',
          modified = '',
          removed = '',
        },
      },
      branch = {
        'branch',
        icon = '󰘬',
        cond = window.is_medium,
      },
      fileformat = {
        'fileformat',
        cond = window.is_medium,
      },
      filename = {
        require('fschauen.lualine').filename,
        padding = {
          left = 1,
          right = 0,
        },
      },
      filetype = {
        colored_if_focused('filetype'),
        cond = window.is_medium,
      },
      mode = require('fschauen.lualine').mode,
      paste = {
        colored_if_focused(function(has_focus) return has_focus and '' or ' ' end),
        color = {
          bg = orange,
        },
        cond = function() return vim.o.paste end
      },
      status = {
        colored_if_focused(function(_)
          local status = ''
          if vim.bo.modified then status = status .. '' end
          if vim.bo.readonly or not vim.bo.modifiable then status = status .. 'RO' end
          return status
        end),
        color = {
          fg = bright,
        },
      },
      trailing_whitespace = {
        colored_if_focused(require('fschauen.lualine').trailing_whitespace),
        color = {
          bg = orange,
        },
      }
    }

    local sections = {
      lualine_a = { C.paste, C.mode },
      lualine_b = { C.branch },
      lualine_c = { C.filename, C.status },
      lualine_x = { C.diagnostics, C.filetype },
      lualine_y = { C.fileformat, 'progress' },
      lualine_z = { 'location', C.trailing_whitespace },
    }

    require('lualine').setup {
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
      sections = sections,
      inactive_sections = sections,
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

