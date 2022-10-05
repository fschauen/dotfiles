local ok, plugin = pcall(require, 'nvim-tree')
if not ok then return end

plugin.setup {
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

  renderer = {
    add_trailing = true,  -- add trailing / to folders
    group_empty = true,   -- folders that contain only one folder are grouped
    highlight_git = true, -- enable highlight based on git attributes
    indent_markers = {
      enable = true,      -- show indent markers
    },
  },
}

vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>tf', '<cmd>NvimTreeFindFileToggle<cr>')

