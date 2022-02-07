local nmap = require'fs.keymap'.nmap

nmap { '<c-n>',     '<cmd>NvimTreeToggle<cr>' }
nmap { '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>' }

-- helper to set vim.g options that will be moved to setup() later
local function set_globals(tbl)
  local g = vim.g
  for k, v in pairs(tbl) do
    g['nvim_tree_' .. k] = v
  end
end

set_globals {
  add_trailing = 1,       -- add trailing / to folders
  group_empty = 1,        -- folders that contain only one folder are grouped
  indent_markers = 1,     -- show indent markers
  git_hl = 1,             -- enable highlight based on git attributes

  icons = {
    default = '',        -- defailt icon for files
    symlink = '',        -- default icon for symlinks
  },
}

require'nvim-tree'.setup {
  auto_close = true,      -- close vim if tree is the last window
  update_cwd = true,      -- refresh tree on DirChanged

  git = {
    ignore = false,       -- don't hide files from .gitignore
  },

  view = {
    width = 35,           -- a little wider than the default 30
  },

  filters = {
    dotfiles = false,     -- show files starting with a .
    custom = { '.git' },  -- don't show .git directory
  },
}

base03  = { cterm =  8, gui = '#002b36' }
base02  = { cterm =  0, gui = '#073642' }
base01  = { cterm = 10, gui = '#586e75' }
base00  = { cterm = 11, gui = '#657b83' }
base0   = { cterm = 12, gui = '#839496' }
base1   = { cterm = 14, gui = '#93a1a1' }
base2   = { cterm =  7, gui = '#eee8d5' }
base3   = { cterm = 15, gui = '#fdf6e3' }
yellow  = { cterm =  3, gui = '#b58900' }
orange  = { cterm =  9, gui = '#cb4b16' }
red     = { cterm =  1, gui = '#dc322f' }
magenta = { cterm =  5, gui = '#d33682' }
violet  = { cterm = 13, gui = '#6c71c4' }
blue    = { cterm =  4, gui = '#268bd2' }
cyan    = { cterm =  6, gui = '#2aa198' }
green   = { cterm =  2, gui = '#859900' }

local function highlight(group, color)
  vim.cmd(
    vim.fn.printf(
      'highlight %s ctermfg=%d guifg=%s',
      group, color.cterm, color.gui))
end

highlight('NvimTreeSpecialFile'  , base2  )
highlight('NvimTreeIndentMarker' , base01 )
highlight('NvimTreeGitStaged'    , green  )
highlight('NvimTreeGitRenamed'   , yellow )
highlight('NvimTreeGitNew'       , yellow )
highlight('NvimTreeGitDirty'     , yellow )
highlight('NvimTreeGitDeleted'   , orange )
highlight('NvimTreeGitMerge'     , red    )

