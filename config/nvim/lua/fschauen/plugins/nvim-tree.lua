local on_attach = function(buffer)
  local api = require("nvim-tree.api")

  -- Give me the default mappings except <c-x>, which I replace with <c-s>.
  api.config.mappings.default_on_attach(buffer)
  vim.keymap.del("n", "<c-x>", { buffer = buffer })

  local map = vim.keymap.set
  local opts = function(desc)
    return {
      desc = "󰙅 nvim-tree: " .. desc,
      buffer = buffer,
      silent = true,
    }
  end

  -- stylua: ignore start
  map("n", "l",     api.node.open.edit,             opts("Open"))
  map("n", "<cr>",  api.node.open.edit,             opts("Open"))
  map("n", "<c-s>", api.node.open.horizontal,       opts("Open: Horizontal Split"))
  map("n", "h",     api.node.navigate.parent_close, opts("Close directory"))
  -- stylua: ignore end
end

return {
  "nvim-tree/nvim-tree.lua",

  dependencies = "nvim-tree/nvim-web-devicons",

  keys = {
    -- stylua: ignore start
    { "<leader>tt", "<cmd>NvimTreeToggle<cr>",   desc = "󰙅 [t]oggle [t]ree" },
    { "<leader>tf", "<cmd>NvimTreeFindFile<cr>", desc = "󰙅 Open [t]ree to current [f]ile " },
    -- stylua: ignore end
  },

  opts = function( --[[plugin]]_, opts)
    local icons = require("fschauen.util.icons")
    return vim.tbl_deep_extend("force", opts or {}, {
      disable_netrw = true, -- replace netrw with nvim-tree
      hijack_cursor = true, -- keep the cursor on begin of the filename
      sync_root_with_cwd = true, -- watch for `DirChanged` and refresh the tree
      on_attach = on_attach,
      git = {
        ignore = false, -- don't hide files from .gitignore
        show_on_open_dirs = false, -- don't show indication if dir is open
      },
      view = {
        adaptive_size = true, -- resize the window based on the longest line
        cursorline = false, -- don't enable 'cursorline' in the tree
        width = 35, -- a little wider than the default 30
      },
      filters = {
        dotfiles = false, -- show files starting with a .
        custom = { "^\\.git" }, -- don't show .git directory
      },
      renderer = {
        add_trailing = true, -- add trailing / to folders
        highlight_git = true, -- enable highlight based on git attributes
        icons = {
          webdev_colors = false, -- highlight icons with NvimTreeFileIcon
          git_placement = "signcolumn",
          glyphs = {
            default = icons.ui.File,
            symlink = icons.ui.FileSymlink,
            modified = icons.ui.Circle,
            folder = {
              arrow_closed = icons.ui.ChevronSmallRight,
              arrow_open = icons.ui.ChevronSmallDown,
              default = icons.ui.Folder,
              open = icons.ui.FolderOpen,
              empty = icons.ui.EmptyFolder,
              empty_open = icons.ui.EmptyFolderOpen,
              symlink = icons.ui.FolderSymlink,
              symlink_open = icons.ui.FolderSymlink,
            },
            git = {
              untracked = icons.git.file.Untracked,
              unstaged = icons.git.file.Unstaged,
              staged = icons.git.file.Staged,
              deleted = icons.git.file.Deleted,
              unmerged = icons.git.file.Unmerged,
              renamed = icons.git.file.Renamed,
              ignored = icons.git.file.Ignored,
            },
          },
        },
      },
    })
  end,
}
