local nmap = require'fs.util.keymap'.nmap
local colors = require'fs.util.color'.colors()

-- helper to set vim.g options that will be moved to setup() later
local function set_globals(tbl)
  local g = vim.g
  for k, v in pairs(tbl) do
    g['nvim_tree_' .. k] = v
  end
end

local function highlight(group, color)
  if vim.opt.termguicolors:get() then
    vim.cmd(vim.fn.printf('highlight %s guifg=%s', group, color))
  else
    vim.cmd(vim.fn.printf('highlight %s ctermfg=%d', group, color))
  end
end

local global_opts ={
  add_trailing = 1,       -- add trailing / to folders
  group_empty = 1,        -- folders that contain only one folder are grouped
  indent_markers = 1,     -- show indent markers
  git_hl = 1,             -- enable highlight based on git attributes

  icons = {
    default = '',        -- defailt icon for files
    symlink = '',        -- default icon for symlinks
  },
}

local nvim_tree_config = {
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

local config = function()
  require'nvim-tree'.setup(nvim_tree_config)

  highlight('NvimTreeSpecialFile'  , colors.base2  )
  highlight('NvimTreeIndentMarker' , colors.base01 )
  highlight('NvimTreeGitStaged'    , colors.green  )
  highlight('NvimTreeGitRenamed'   , colors.yellow )
  highlight('NvimTreeGitNew'       , colors.yellow )
  highlight('NvimTreeGitDirty'     , colors.yellow )
  highlight('NvimTreeGitDeleted'   , colors.orange )
  highlight('NvimTreeGitMerge'     , colors.red    )

  nmap { '<c-n>',     '<cmd>NvimTreeToggle<cr>' }
  nmap { '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>' }
end

return { config = config }

