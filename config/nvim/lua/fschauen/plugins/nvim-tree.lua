local config = function()
  require('nvim-tree').setup {
    disable_netrw = true,       -- replace netrw with nvim-tree
    hijack_cursor = true,       -- keep the cursor on begin of the filename
    sync_root_with_cwd = true,  -- watch for `DirChanged` and refresh the tree

    on_attach = function(bufnr)
      local api = require('nvim-tree.api')
      api.config.mappings.default_on_attach(bufnr)

      local opts = function(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, silent = true }
      end

      vim.keymap.set('n', 'l',    api.node.open.edit,             opts('open'))
      vim.keymap.set('n', '<CR>', api.node.open.edit,             opts('open'))
      vim.keymap.set('n', 'o',    api.node.open.edit,             opts('open'))
      vim.keymap.set('n', 'h',    api.node.navigate.parent_close, opts('close directory'))
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
end

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
