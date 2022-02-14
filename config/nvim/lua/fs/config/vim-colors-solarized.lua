local util = require'fs.util'
local C = util.colors()
local highlight = util.highlight

local additional_highlights = {
  -- Override the colorscheme for these ones:
  Normal       = { bg = 'NONE' },                   -- transparent background
  NonText      = { fg = C.base02, attrs = 'NONE' }, -- very subtle EOL symbols
  Whitespace   = { fg = C.orange },                 -- listchars
  SpellBad     = { fg = C.yellow },                 -- spelling mistakes
  QuickFixLine = { fg = C.yellow, bg = C.base02 },  -- selected quickfix item
  CursorLineNr = { fg = C.yellow, attrs = 'NONE' }, -- current line number

  -- Trailing whitespace, from 'ntpeters/vim-better-whitespace':
  ExtraWhitespace = { fg = C.orange, bg = C.orange },

  -- Indentation guids, from 'lukas-reineke/indent-blankline.nvim':
  IndentBlanklineChar = { fg = C.base01 },

  -- Virtual colorcolumn, from 'lukas-reineke/virt-column.nvim':
  VirtColumn = { fg = C.base02, bg = C.base03, attrs = 'NONE' },

  -- Colors for 'kyazdani42/nvim-tree.lua':
  NvimTreeSpecialFile  = { fg = C.base2  },
  NvimTreeIndentMarker = { fg = C.base01 },
  NvimTreeGitStaged    = { fg = C.green  },
  NvimTreeGitRenamed   = { fg = C.yellow },
  NvimTreeGitNew       = { fg = C.yellow },
  NvimTreeGitDirty     = { fg = C.yellow },
  NvimTreeGitDeleted   = { fg = C.orange },
  NvimTreeGitMerge     = { fg = C.red    },

  -- Colors for 'nvim-telescope/telescope.nvim':
  TelescopeBorder         = { fg = C.base01 },
  TelescopeTitle          = { fg = C.base1 },
  TelescopePromptPrefix   = { fg = C.red },
  TelescopePromptCounter  = { fg = C.base1 },
  TelescopeMatching       = { fg = C.red },
  TelescopeSelection      = { fg = C.base2, bg = C.base02, attrs = 'NONE' },
  TelescopeMultiSelection = { fg = C.blue },
  TelescopeMultiIcon      = { fg = C.blue },
}

local config = function()
  vim.cmd [[silent! colorscheme solarized]]

  for group, hl in pairs(additional_highlights) do
    highlight(group, hl)
  end
end

return { config = config }

