local util = require'fs.util'
local nmap = util.nmap
local colors = util.colors()
local highlight = util.highlight

-- helper to set vim.g options that will be moved to setup() later
local function set_globals(tbl)
  local g = vim.g
  for k, v in pairs(tbl) do
    g['nvim_tree_' .. k] = v
  end
end

local config = function()
  set_globals {
    add_trailing = 1,       -- add trailing / to folders
    group_empty = 1,        -- folders that contain only one folder are grouped
    indent_markers = 1,     -- show indent markers
    git_hl = 1,             -- enable highlight based on git attributes

    icons = {
      default = '',        -- default icon for files
      symlink = '',        -- default icon for symlinks
    },
  }

  require'nvim-tree'.setup {
    auto_close = true,      -- close vim if tree is the last window

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

  highlight('NvimTreeSpecialFile')  { fg = colors.base2  }
  highlight('NvimTreeIndentMarker') { fg = colors.base01 }
  highlight('NvimTreeGitStaged')    { fg = colors.green  }
  highlight('NvimTreeGitRenamed')   { fg = colors.yellow }
  highlight('NvimTreeGitNew')       { fg = colors.yellow }
  highlight('NvimTreeGitDirty')     { fg = colors.yellow }
  highlight('NvimTreeGitDeleted')   { fg = colors.orange }
  highlight('NvimTreeGitMerge')     { fg = colors.red    }

  nmap { '<c-n>',     '<cmd>NvimTreeToggle<cr>' }
  nmap { '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>' }
end

return { config = config }

