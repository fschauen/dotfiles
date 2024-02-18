local M = { 'nvim-tree/nvim-tree.lua' }

M.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

M.keys = {
  { '<leader>tt', '<cmd>NvimTreeToggle<cr>', desc = '󰙅 [t]oggle [t]ree' },
  { '<leader>tf',  '<cmd>NvimTreeFindFile<cr>', desc = '󰙅 Open [t]ree to current [f]ile ' },
}

M.opts = function(--[[plugin]]_, opts)
  local icons = require('fschauen.icons')
  return vim.tbl_deep_extend('force', opts, {
    disable_netrw = true,       -- replace netrw with nvim-tree
    hijack_cursor = true,       -- keep the cursor on begin of the filename
    sync_root_with_cwd = true,  -- watch for `DirChanged` and refresh the tree

    on_attach = function(buffer)
      local api = require('nvim-tree.api')

      -- Give me the default mappings except <c-x>, which I replace with <c-s>.
      api.config.mappings.default_on_attach(buffer)
      vim.keymap.del('n', '<c-x>', { buffer = buffer })

      local opt = function(desc)
        return { desc = '󰙅 nvim-tree: ' .. desc, buffer = buffer, silent = true }
      end
      vim.keymap.set('n', 'l',     api.node.open.edit,             opt('Open'))
      vim.keymap.set('n', '<cr>',  api.node.open.edit,             opt('Open'))
      vim.keymap.set('n', '<c-s>', api.node.open.horizontal,       opt('Open: Horizontal Split'))
      vim.keymap.set('n', 'h',     api.node.navigate.parent_close, opt('Close directory'))
    end,

    git = {
      ignore = false,             -- don't hide files from .gitignore
      show_on_open_dirs = false,  -- don't show indication if dir is open
    },
    view = {
      adaptive_size = true, -- resize the window based on the longest line
      cursorline = false,   -- don't enable 'cursorline' in the tree
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
        webdev_colors = false,    -- highlight icons with NvimTreeFileIcon
        git_placement = 'signcolumn',
        glyphs = {
          default = icons.ui.File,
          symlink = icons.ui.FileSymlink,
          modified = icons.ui.Circle,
          folder = {
            arrow_closed = icons.ui.ChevronSmallRight,
            arrow_open   = icons.ui.ChevronSmallDown,
            default      = icons.ui.Folder,
            open         = icons.ui.FolderOpen,
            empty        = icons.ui.EmptyFolder,
            empty_open   = icons.ui.EmptyFolderOpen,
            symlink      = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderSymlink,
          },
          git = {
            untracked = icons.git.file.Untracked,
            unstaged  = icons.git.file.Unstaged,
            staged    = icons.git.file.Staged,
            deleted   = icons.git.file.Deleted,
            unmerged  = icons.git.file.Unmerged,
            renamed   = icons.git.file.Renamed,
            ignored   = icons.git.file.Ignored,
          },
        },
      },
    },
  })
end

return M

