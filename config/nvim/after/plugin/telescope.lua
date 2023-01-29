local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then return end

local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

local common_mappings = {
  ['<c-l>'] = actions_layout.cycle_layout_next,
  ['<c-o>'] = actions_layout.toggle_mirror,
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
      { layout_strategy = 'bottom_pane', layout_config = { width = 1, height = 0.4 }, },
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

  pickers = {
    buffers     = { prompt_title = ' ﬘ Find buffers '   },
    find_files  = { prompt_title = '   Find files '    },
    git_commits = { prompt_title = '  Find commits ' },
    help_tags   = { prompt_title = ' ﬤ Find help tags ' },
    keymaps     = { prompt_title = '   Find keymaps '  },
    live_grep   = { prompt_title = ' 🔍 Grep '          },
    vim_options = { prompt_title = '  Find options '   },
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

local builtin = require 'telescope.builtin'

local custom = {
  dotfiles = function()
    builtin.find_files {
      prompt_title = '  Find dotfiles ',
      cwd = '~/.dotfiles',
      hidden = true,
    }
  end,

  man_pages = function()
    builtin.man_pages {
      prompt_title = '   Find man pages ',
      sections = { 'ALL' },
      man_cmd = { "apropos", ".*" }
    }
  end,
}

local map = vim.keymap.set

map('n', '<leader>fb', builtin.buffers,     { desc = 'Telescope: find buffers' })
map('n', '<leader>fc', builtin.git_commits, { desc = 'Telescope: find commits' })
map('n', '<leader>fd', custom.dotfiles,     { desc = 'Telescope: find in dotfiles' })
map('n', '<leader>ff', builtin.find_files,  { desc = 'Telescope: find files in $PWD' })
map('n', '<leader>fg', builtin.live_grep,   { desc = 'Telescope: live grep in $PWD' })
map('n', '<leader>fh', builtin.help_tags,   { desc = 'Telescope: find help tags' })
map('n', '<leader>fk', builtin.keymaps,     { desc = 'Telescope: find keymaps' })
map('n', '<leader>fm', custom.man_pages,    { desc = 'Telescope: find man pages' })
map('n', '<leader>fo', builtin.vim_options, { desc = 'Telescope: find vim options' })



local loaded_file_browser, _ = pcall(telescope.load_extension, 'file_browser')
if loaded_file_browser then
  map('n', '<leader>br', '<cmd>Telescope file_browser<cr>')
else
  vim.notify('Telescope file_browser not installed!', vim.log.levels.WARN)
end

