local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then return end

local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

local common_mappings = {
  ['<c-l>'] = actions_layout.cycle_layout_next,
  ['<c-h>'] = actions_layout.cycle_layout_prev,

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

local map = vim.keymap.set

local loaded_file_browser, _ = pcall(telescope.load_extension, 'file_browser')
if loaded_file_browser then
  map('n', '<leader>br', '<cmd>Telescope file_browser<cr>')
else
  vim.notify('Telescope file_browser not installed!', vim.log.levels.WARN)
end

local builtin = require 'telescope.builtin'

map('n', '<leader>fb',
  function() builtin.buffers { prompt_title = ' ﬘ Find buffers ' } end,
  { desc = 'Telescope: find buffers' })

map('n', '<leader>fc',
  function() builtin.git_commits { prompt_title = '  Find commits ' } end,
  { desc = 'Telescope: find commits' })

map('n', '<leader>fd',
  function()
    builtin.find_files {
      prompt_title = '  Find dotfiles ',
      cwd = '~/.dotfiles',
      hidden = true,
    }
  end,
  { desc = 'Telescope: find in dotfiles' })

map('n', '<leader>ff',
  function() builtin.find_files { prompt_title = '   Find files ' } end,
  { desc = 'Find files in $PWD (Telescope)' })

map('n', '<leader>fg',
  function() builtin.live_grep { prompt_title = ' 🔍 Grep ' } end,
  { desc = 'Live grep in $PWD (Telescope)' })

map('n', '<leader>fh',
  function() builtin.help_tags { prompt_title = ' ﬤ Find help tags ' } end,
  { desc = 'Telescope: find help tags' })

map('n', '<leader>fk',
  function() builtin.keymaps { prompt_title = '   Find keymaps ' } end,
  { desc = 'Telescope: find keymaps' })

map('n', '<leader>fm',
  function()
    builtin.man_pages {
      prompt_title = '   Find man pages ',
      sections = { 'ALL' },
    }
  end,
  { desc = 'Telescope: find man pages' })

map('n', '<leader>fo',
  function()
    builtin.vim_options {
      prompt_title = '  Find options ',
      layout_config = {
        width = 0.75,
        height = 0.8,
      }
    }
  end,
  { desc = 'Telescope: find options' })

