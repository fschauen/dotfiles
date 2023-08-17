local M = { 'nvim-tree/nvim-tree.lua' }

M.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

M.keys = {
  { '<leader>nn', '<cmd>NvimTreeOpen<cr>' },
  { '<leader>nf', '<cmd>NvimTreeFindFile<cr>' },
  { '<leader>nc', '<cmd>NvimTreeClose<cr>' },
}

M.opts = {
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
    highlight_git = true, -- enable highlight based on git attributes
    icons = {
      git_placement = 'after',
      glyphs = {
        default = '',
        symlink = '',
        modified = '●',
        folder = {
          arrow_closed = '',   --     
          arrow_open = '',     --     
          default = '',        --   
          open = '',           --   
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
        git = {
          untracked = '?',      -- ★
          unstaged = '✶',       -- ✗
          staged = '',         -- ✓
          deleted = '',
          unmerged = '',
          renamed = '➜',
          ignored = '◌',
        },
      },
    },
  },
}

return M

