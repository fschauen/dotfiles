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


local function highlight(group, color)
  if vim.opt.termguicolors:get() then
    vim.cmd(vim.fn.printf('highlight %s guifg=%s', group, color))
  else
    vim.cmd(vim.fn.printf('highlight %s ctermfg=%d', group, color))
  end
end

local C = require'fs.colors'.colors()

highlight('NvimTreeSpecialFile'  , C.base2  )
highlight('NvimTreeIndentMarker' , C.base01 )
highlight('NvimTreeGitStaged'    , C.green  )
highlight('NvimTreeGitRenamed'   , C.yellow )
highlight('NvimTreeGitNew'       , C.yellow )
highlight('NvimTreeGitDirty'     , C.yellow )
highlight('NvimTreeGitDeleted'   , C.orange )
highlight('NvimTreeGitMerge'     , C.red    )

