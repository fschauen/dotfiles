local nt, callback

local ok, _ = pcall(function()
  nt = require 'nvim-tree'
  api = require 'nvim-tree.api'
end)

if not ok then return end

nt.setup {
  disable_netrw = true,       -- replace netrw with nvim-tree
  hijack_cursor = true,       -- keep the cursor on begin of the filename
  sync_root_with_cwd = true,  -- watch for `DirChanged` and refresh the tree

  on_attach = function()
    for _, lhs in ipairs({'l', '<CR>', 'o'}) do
      vim.keymap.set('n', lhs, api.node.open.edit)
    end
    vim.keymap.set('n', 'h', api.node.navigate.parent_close)
  end,

  git = {
    ignore = false,       -- don't hide files from .gitignore
  },

  view = {
    adaptive_size = true, -- resize the window based on the longest line
    width = 35,           -- a little wider than the default 30
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

