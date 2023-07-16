local config = function()
  local telescope      = require 'telescope'
  local actions        = require 'telescope.actions'
  local actions_layout = require 'telescope.actions.layout'

  local mappings = {
    ['<c-l>'] = actions_layout.cycle_layout_next,
    ['<c-o>'] = actions_layout.toggle_mirror,
    ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
    ['<c-c>'] = actions.close,

    ['<s-down>'] = actions.preview_scrolling_down,
    ['<s-up>']   = actions.preview_scrolling_up,

    ['<c-j>'] = actions.cycle_history_next,
    ['<c-k>'] = actions.cycle_history_prev,
  }

  telescope.setup {
    defaults = {
      prompt_prefix = ' ❯ ',
      selection_caret = ' ',     -- Other ideas:  ➔  
      multi_icon = ' ',
      scroll_strategy = 'limit',  -- Don't wrap around in results.

      layout_strategy = 'flex',
      layout_config = {
        anchor     = 'center',
        width      = 0.9,
        height     = 0.9,
        flex       = { flip_columns   = 130 },
        horizontal = { preview_width  = 0.5, preview_cutoff = 130 },
        vertical   = { preview_height = 0.5 },
      },

      cycle_layout_list = { 'horizontal', 'vertical' },

      mappings = { i = mappings, n = mappings },
    },

    extensions = {
      file_browser = { theme = 'ivy' },
    },
  }

  local builtin = require 'telescope.builtin'

  local custom = {
    all_files = function(opts)
      builtin.find_files(vim.tbl_extend('keep', opts or {}, {
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      }))
    end,

    dotfiles = function(opts)
      builtin.find_files(vim.tbl_extend('keep', opts or {}, {
        cwd = '~/.dotfiles',
        hidden = true,
      }))
    end,

    grep = function(_)
      local selected = require('user.util').get_selected_text()
      builtin.grep_string {
        prompt_title = string.format('    Grep: %s   ', selected),
        search = selected,
      }
    end,

    here = function(opts) builtin.current_buffer_fuzzy_find(opts) end,
  }

  local map = function(keymap)
    for _, r in ipairs(keymap) do
      local modes, lhs, picker, title, desc = r[1], r[2], r[3], r[4], r[5]
      local rhs = function() picker { prompt_title = title } end
      vim.keymap.set(modes, lhs, rhs, { desc = desc })
    end
  end

  map {
  -- ╭────╮   ╭────╮        ╭──────╮                ╭────────────╮             ╭───────────────────╮
  -- │mode│   │keys│        │picker│                │prompt title│             │mapping description│
  -- ╰────╯   ╰────╯        ╰──────╯                ╰────────────╯             ╰───────────────────╯
    { 'n', '<leader>fa', custom.all_files    , '    ALL Files  '          , ' [F]ind [A]ll Files in $PWD'  },
    { 'n', '<leader>fb', builtin.buffers     , '    Buffers  '            , ' [F]ind [B]uffers'            },
    { 'n', '<leader>fc', builtin.git_commits , '   Commits  '           , ' [F]ind [C]ommits'            },
    { 'n', '<leader>fd', custom.dotfiles     , '    Find dotfiles  '      , ' [F]ind [D]otfiles'           },
    { 'n', '<leader>ff', builtin.find_files  , '    Files  '              , ' [F]ind [F]iles in $PWD'      },
    { 'n', '<leader>fg', builtin.live_grep   , '    Live grep  '          , ' [F]ind with [G]rep in $PWD'  },
    { 'n', '<leader>fh', custom.here         , '    Current buffer  '     , ' [F]ind [H]ere'               },
    { 'n', '<leader>fk', builtin.keymaps     , '    Keymaps  '            , ' [F]ind [K]eymaps'            },
    { 'n', '<leader>fm', builtin.man_pages   , '    Man pages  '          , ' [F]ind [M]an pages'          },
    { 'n', '<leader>fo', builtin.vim_options , '    Vim options  '        , ' [F]ind vim [O]ptions'        },
    { 'n', '<leader>fs', custom.grep,            nil                       , ' [F]ind [S]tring'             },
    { 'n', '<leader>fs', custom.grep,            nil                       , ' [F]ind visual [S]election'   },
    { 'n', '<leader>ft', builtin.treesitter  , '    Treesitter Symbols  ' , ' [F]ind [T]reesitter Symbols' },
    { 'n', '<leader>f?', builtin.help_tags   , '    Help tags  '          , ' [F]ind Help tags [?]'        },
  }

  telescope.load_extension 'fzf'

  telescope.load_extension 'file_browser'
  vim.keymap.set('n', '<leader>br', '<cmd>Telescope file_browser<cr>', { desc = ' file [BR]owser' })
end

return {
  'nvim-telescope/telescope.nvim',

  config = config,
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
              '&& cmake --build build --config Release ' ..
              '&& cmake --install build --prefix build'
    },
  },
}

