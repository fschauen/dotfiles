local nt, callback

local ok, _ = pcall(function()
  nt = require 'nvim-tree'
  callback = require 'nvim-tree.config'.nvim_tree_callback
end)

if not ok then return end

nt.setup {
  disable_netrw = true,       -- replace netrw with nvim-tree
  hijack_cursor = true,       -- keep the cursor on begin of the filename
  sync_root_with_cwd = true,  -- watch for `DirChanged` and refresh the tree

  git = {
    ignore = false,       -- don't hide files from .gitignore
  },

  view = {
    adaptive_size = true, -- resize the window based on the longest line
    width = 35,           -- a little wider than the default 30
    mappings = {
      list = {
        { key = { 'l', '<CR>', 'o' }, cb = callback 'edit' },
        { key = 'h', cb = callback 'close_node' },
      },
    },
  },

  filters = {
    dotfiles = false,         -- show files starting with a .
    custom = { '^\\.git' },   -- don't show .git directory
  },

  renderer = {
    add_trailing = true,  -- add trailing / to folders
    group_empty = true,   -- folders that contain only one folder are grouped
    highlight_git = true, -- enable highlight based on git attributes
  },
}

vim.keymap.set('n', '<leader>nn', '<cmd>NvimTreeOpen<cr>')
vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>')
vim.keymap.set('n', '<leader>nc', '<cmd>NvimTreeClose<cr>')

