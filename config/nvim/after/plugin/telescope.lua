local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then return end

local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

local common_mappings = {
  ['<c-l>'] = actions_layout.cycle_layout_next,
  ['<c-h>'] = actions_layout.cycle_layout_prev,

  ['<c-i>'] = actions_layout.toggle_mirror,

  ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
}

telescope.setup {
  defaults = {
    prompt_prefix = '❯ ',
    selection_caret = ' ',   -- Other ideas: ➔ 
    multi_icon = ' ',

    layout_strategy = 'flex',
    layout_config = {
      anchor = 'center',
      width = 0.9,
      height = 0.9,

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

    cycle_layout_list = {
      { layout_strategy = 'cursor', layout_config = { width = 0.5, height = 0.4 }, },
      { layout_strategy = 'bottom_pane', layout_config = { width = 0.9, height = 0.4 }, },
      'horizontal',
      'vertical',
    },

    mappings = {
      i = vim.tbl_extend('force', common_mappings, {
        ['<c-j>'] = actions.cycle_history_next,
        ['<c-k>'] = actions.cycle_history_prev,

      }),
      n = common_mappings,
    },
  },

  extensions = {
    file_browser = {
      theme = 'ivy',
      mappings = {
        n = {
          -- normal mode mappings go here
        },
        i = {
         -- insert mode mappings go here
        },
      },
    },
  },
}

local loaded_file_browser, _ = pcall(telescope.load_extension, 'file_browser')
if loaded_file_browser then
  vim.keymap.set('n', '<leader>br', '<cmd>Telescope file_browser<cr>')
else
  print('Telescope file_browser not installed!')
end

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

vim.keymap.set('n', '<leader>fb', find_buffers)
vim.keymap.set('n', '<leader>fc', find_commits)
vim.keymap.set('n', '<leader>fd', find_dotfiles)
vim.keymap.set('n', '<leader>ff', find_files)
vim.keymap.set('n', '<leader>fg', find_grep)
vim.keymap.set('n', '<leader>fh', find_help)
vim.keymap.set('n', '<leader>fk', find_keymaps)
vim.keymap.set('n', '<leader>fm', find_manpages)
vim.keymap.set('n', '<leader>fo', find_options)

