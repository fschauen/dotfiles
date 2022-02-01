local colors = {}
if vim.opt.termguicolors:get() then
  colors = {
    base03  = '#002b36',    yellow  = '#b58900',
    base02  = '#073642',    orange  = '#cb4b16',
    base01  = '#586e75',    red     = '#dc322f',
    base00  = '#657b83',    magenta = '#d33682',
    base0   = '#839496',    violet  = '#6c71c4',
    base1   = '#93a1a1',    blue    = '#268bd2',
    base2   = '#eee8d5',    cyan    = '#2aa198',
    base3   = '#fdf6e3',    green   = '#859900',
  }
else
  colors = {
    base03  =  8,           yellow  =  3,
    base02  =  0,           orange  =  9,
    base01  = 10,           red     =  1,
    base00  = 11,           magenta =  5,
    base0   = 12,           violet  = 13,
    base1   = 14,           blue    =  4,
    base2   =  7,           cyan    =  6,
    base3   = 15,           green   =  2,
  }
end

local progress = { '%3p%%×%L %3l:%-2v', padding = { left = 0, right = 1 } }
local relative_path = { 'filename', path = 1 }
local encoding = function ()
  local fenc = vim.opt.fileencoding:get()
  if fenc ~= '' then
    return fenc
  end
  return vim.opt.encoding:get()
end
local fileformat = { 'fileformat', padding = { left = 0, right = 1} }

require('lualine').setup {
    options = {
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      theme = {
        normal = {
          a = { fg = colors.base03, bg = colors.blue, gui='bold' },
          b = { fg = colors.base2,  bg = colors.base00    },
          c = { fg = colors.base1,  bg = colors.base02    },
        },
        insert  = { a = { fg = colors.base03, bg = colors.green,   gui = 'bold' } },
        visual  = { a = { fg = colors.base03, bg = colors.magenta, gui = 'bold' } },
        replace = { a = { fg = colors.base03, bg = colors.red,     gui = 'bold' } },
        inactive = {
          a = { fg = colors.base1,  bg = colors.base00    },
          b = { fg = colors.base0,  bg = colors.base01    },
          c = { fg = colors.base00, bg = colors.base02    },
        },
      },
    },

    sections = {
      lualine_a = {
        'mode',
        {
          function() return 'PASTE' end,
          color = { bg = colors.yellow },
          cond = function() return vim.opt.paste:get() end
        },
      },
      lualine_b = { 'diagnostics', 'branch' },
      lualine_c = { relative_path },
      lualine_x = { 'filetype' },
      lualine_y = { encoding, fileformat },
      lualine_z = { progress },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = { 'diagnostics', 'branch' },
      lualine_c = { relative_path },
      lualine_x = { 'filetype' },
      lualine_y = { encoding, fileformat },
      lualine_z = { progress },
    },

    extensions = { 'fugitive', 'quickfix' }
}

