local nmap = require'fs.util'.nmap

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

  nmap { '<c-n>',     '<cmd>NvimTreeToggle<cr>' }
  nmap { '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>' }
end

return { config = config }

