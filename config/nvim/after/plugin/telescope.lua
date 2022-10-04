local ok, telescope = pcall(require, 'telescope')
if not ok then return end

local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

local find_buffers = function()
  builtin.buffers { prompt_title = ' ﬘ Find buffers ' }
end

local find_commits = function()
  builtin.git_commits { prompt_title = '  Find git commits ' }
end

local find_dotfiles = function()
  builtin.find_files {
    prompt_title = '  Find dotfiles ',
    cwd = '~/.dotfiles',
    hidden = true,
  }
end

local find_files = function()
  builtin.find_files { prompt_title = '   Find files ' }
end

local find_grep = function()
  builtin.live_grep { prompt_title = ' 🔍 Grep ' }
end

local find_help = function()
  builtin.help_tags { prompt_title = ' ﬤ Find help tags ' }
end

local find_keymaps = function()
  builtin.keymaps { prompt_title = '   Find keymaps ' }
end

local find_manpages = function()
  builtin.man_pages {
    prompt_title = '   Find man pages ',
    sections = { 'ALL' },
  }
end

local find_options = function()
  builtin.vim_options {
    prompt_title = '  Find nvim options ',
    layout_config = {
      width = 0.75,
      height = 0.8,
    }
  }
end

telescope.setup {
  defaults = {
    prompt_prefix = '❯ ',
    selection_caret = '➔ ',

    layout_strategy = 'flex',
    layout_config = {
      anchor = 'center',
      width = 0.92,
      height = 0.95,

      flex = {
        flip_columns = 130,
      },

      horizontal = {
        preview_width = 0.5,
        preview_cutoff = 130,
      },

      vertical = {
        preview_height = 0.5,
      },
    },

    mappings = {
      i = {
        ['<c-j>'] = actions.cycle_history_next,
        ['<c-k>'] = actions.cycle_history_prev,
      },
    },
  },
}

vim.keymap.set('n', '<leader>fb', find_buffers)
vim.keymap.set('n', '<leader>fc', find_commits)
vim.keymap.set('n', '<leader>fd', find_dotfiles)
vim.keymap.set('n', '<leader>ff', find_files)
vim.keymap.set('n', '<leader>fg', find_grep)
vim.keymap.set('n', '<leader>fh', find_help)
vim.keymap.set('n', '<leader>fk', find_keymaps)
vim.keymap.set('n', '<leader>fm', find_manpages)
vim.keymap.set('n', '<leader>fo', find_options)

