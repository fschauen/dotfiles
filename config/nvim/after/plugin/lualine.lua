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

local C = require'fs.colors'.colors()

require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = {
      normal = {
        a = { fg = C.base03, bg = C.blue, gui='bold' },
        b = { fg = C.base03,  bg = C.base00    },
        c = { fg = C.base1,  bg = C.base02    },
      },
      insert  = { a = { fg = C.base03, bg = C.green,   gui = 'bold' } },
      visual  = { a = { fg = C.base03, bg = C.magenta, gui = 'bold' } },
      replace = { a = { fg = C.base03, bg = C.red,     gui = 'bold' } },
      inactive = {
        a = { fg = C.base1,  bg = C.base00    },
        b = { fg = C.base0,  bg = C.base01    },
        c = { fg = C.base01, bg = C.base02    },
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

