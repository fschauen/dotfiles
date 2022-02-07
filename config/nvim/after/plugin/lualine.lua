local gui = vim.opt.termguicolors:get()

local function color(tbl)
  if gui then return tbl.gui end
  return tbl.index
end

base03  = color { index =  8, gui = '#002b36' }
base02  = color { index =  0, gui = '#073642' }
base01  = color { index = 10, gui = '#586e75' }
base00  = color { index = 11, gui = '#657b83' }
base0   = color { index = 12, gui = '#839496' }
base1   = color { index = 14, gui = '#93a1a1' }
base2   = color { index =  7, gui = '#eee8d5' }
base3   = color { index = 15, gui = '#fdf6e3' }
yellow  = color { index =  3, gui = '#b58900' }
orange  = color { index =  9, gui = '#cb4b16' }
red     = color { index =  1, gui = '#dc322f' }
magenta = color { index =  5, gui = '#d33682' }
violet  = color { index = 13, gui = '#6c71c4' }
blue    = color { index =  4, gui = '#268bd2' }
cyan    = color { index =  6, gui = '#2aa198' }
green   = color { index =  2, gui = '#859900' }

local paste = {
  function() return 'P' end,
  color = { fg = base3, bg = yellow, gui = 'bold' },
  cond = function() return vim.opt.paste:get() end
}

local relative_path = {
  'filename',
  path = 1  -- 0: just filenane, 1: realtive path, 2: absolute path
}

local encoding = function ()
  local fenc = vim.opt.fileencoding:get()
  if fenc ~= '' then
    return fenc
  end
  return vim.opt.encoding:get()
end

-- let padding when using icons leaves too much space
local fileformat = { 'fileformat', padding = { left = 0, right = 1}}

local progress = '%3l/%L｜%-2v'  -- line / total ｜column

require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = {
      normal = {
        a = { fg = base03, bg = blue, gui='bold' },
        b = { fg = base2,  bg = base00    },
        c = { fg = base1,  bg = base02    },
      },
      insert  = { a = { fg = base03, bg = green,   gui = 'bold' } },
      visual  = { a = { fg = base03, bg = magenta, gui = 'bold' } },
      replace = { a = { fg = base03, bg = red,     gui = 'bold' } },
      inactive = {
        a = { fg = base1,  bg = base00    },
        b = { fg = base0,  bg = base01    },
        c = { fg = base00, bg = base02    },
      },
    },
  },

  sections = {
    lualine_a = { 'mode', paste },
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
    lualine_x = { { 'filetype', colored = false } },
    lualine_y = { encoding, fileformat },
    lualine_z = { progress },
  },

  extensions = { 'fugitive', 'quickfix' }
}

