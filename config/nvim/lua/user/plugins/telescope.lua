local config = function()
  local telescope      = require 'telescope'
  local actions        = require 'telescope.actions'
  local actions_layout = require 'telescope.actions.layout'

  local mappings = {
    ['<c-l>'] = actions_layout.cycle_layout_next,
    ['<c-o>'] = actions_layout.toggle_mirror,
    ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
    ['<a-q>'] = actions.smart_send_to_loclist + actions.open_loclist,
    ['<c-c>'] = actions.close,

    ['<s-down>'] = actions.preview_scrolling_down,
    ['<s-up>']   = actions.preview_scrolling_up,

    ['<c-j>'] = actions.cycle_history_next,
    ['<c-k>'] = actions.cycle_history_prev,
  }

  telescope.setup {
    defaults = {
      -- ╭────────╮
      -- │ Keymap │
      -- ╰────────╯
      mappings = { i = mappings, n = mappings },

      -- ╭────────╮
      -- │ Prompt │
      -- ╰────────╯
      prompt_prefix = ' ❯ ',
      selection_caret = ' ',     -- Other ideas:  ➔  

      -- ╭─────────╮
      -- │ Results │
      -- ╰─────────╯
      multi_icon = ' ',
      scroll_strategy = 'limit',  -- Don't wrap around in results.

      -- ╭─────────╮
      -- │ Preview │
      -- ╰─────────╯
      dynamic_preview_title = true,

      -- ╭────────╮
      -- │ Layout │
      -- ╰────────╯
      layout_strategy = 'flex',
      layout_config = {
        width      = 0.9,
        height     = 0.9,
        flex       = { flip_columns   = 130 },
        horizontal = { preview_width  = 0.5, preview_cutoff = 130 },
        vertical   = { preview_height = 0.5 },
      },
      cycle_layout_list = { 'horizontal', 'vertical' },
    },

    extensions = {
      file_browser = { theme = 'ivy' },
    },
  }

  local themes = require 'telescope.themes'
  local builtin = require 'telescope.builtin'
  local custom = {
    all_files = function(opts)
      builtin.find_files(vim.tbl_extend('keep', opts or {}, {
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      }))
    end,
    colorschemes = function(opts)
      builtin.colorscheme(themes.get_dropdown(vim.tbl_extend('keep', opts or {}, {
        enable_preview = true,
      })))
    end,
    dotfiles = function(opts)
      builtin.find_files(vim.tbl_extend('keep', opts or {}, {
        cwd = '~/.dotfiles',
        hidden = true,
      }))
    end,
    selection = function(_)
      local selected = require('user.util').get_selected_text()
      builtin.grep_string {
        prompt_title = string.format('    Grep: %s   ', selected),
        search = selected,
      }
    end,
    spell_suggest = function(opts)
      builtin.spell_suggest(themes.get_cursor(opts))
    end,
    here = function(opts)
      builtin.current_buffer_fuzzy_find(opts)
    end,
  }

  local map = function(leader, keymap)
    for mode, list in pairs(keymap) do
      for _, row in ipairs(list) do
        local lhs, picker, title, desc = row[1], row[2], row[3], row[4]
        local rhs = function() picker { prompt_title = ' ' .. title .. ' ' } end
        vim.keymap.set(mode, leader .. lhs, rhs, { desc = '  ' .. desc })
      end
    end
  end

  map('<c-p>', {
    -- ╭────╮     ╭──────╮                ╭────────────╮          ╭───────────────────╮
    -- │keys│     │picker│                │prompt title│          │mapping description│
    -- ╰────╯     ╰──────╯                ╰────────────╯          ╰───────────────────╯
    n = {
      { 'a',  builtin.autocommands   , '  Autocommands'         , '[a]utocommands'         },
      { 'b',  builtin.buffers        , '  Buffers'              , '[b]uffers'              },
      { 'c',  custom.colorschemes    , '  Colorschemes'         , '[c]olorschemes'         },
      { 'd',  custom.dotfiles        , '  Dotfiles'             , '[d]ot[f]iles'           },
      { 'e',  builtin.diagnostics    , '󰀪  Diagnostics'          , 'diagnostics/[e]rrors'   },
      { 'f',  builtin.find_files     , '  Files'                , '[f]ind files'           },
      { 'F',  custom.all_files       , '  ALL files'            , 'all [F]iles'            },
      { 'gr', builtin.live_grep      , '  Live grep'            , 'Live [gr]ep'            },
      { 'gf', builtin.git_files      , '  Git files'            , '[g]it [f]iles'          },
      { 'gc', builtin.git_commits    , ' Commits'             , '[g]it [c]ommits'        },
      { 'h',  custom.here            , '  Current buffer'       , '[b]uffer [h]ere'        },
      { 'H',  builtin.highlights     , '󰌶  Highlights'           , '[H]ighlights'           },
      -- i
      { 'j',  builtin.jumplist       , '  Jumplist'             , '[j]umplist'             },
      { 'k',  builtin.keymaps        , '  Keymaps'              , '[k]eymaps'              },
      { 'K',  builtin.help_tags      , '  Help tags'            , '[K] help/documentation' },
      { 'l',  builtin.loclist        , '  Location list'        , '[l]ocation List'        },
      { 'm',  builtin.man_pages      , '  Man pages'            , '[m]an pages'            },
      -- n
      { 'o',  builtin.vim_options    , '  Vim options'          , 'vim [o]ptions'          },
      -- p
      { 'q',  builtin.quickfix       , '  Quickfix'             , '[q]uickfix'             },
      { 'r',  builtin.registers      , '󱓥  Registers'            , '[r]registers'           },
      { 'R',  builtin.resume         , '󰐎  Resume'               , '[R]esume'               },
      { 's',  custom.selection       , '' --[[dynamic]]          , '[s]selection'           },
      { 't',  builtin.treesitter     , '  Treesitter symbols'   , '[t]reesitter Symbols'   },
      -- u
      -- v
      -- w
      -- x
      -- y
      { 'z',  custom.spell_suggest   , '󰓆  Spelling suggestions' , '[z] spell suggestions'  },
      { ':',  builtin.command_history, '  Command history'      , '[:]command history'     },
      { '?',  builtin.commands       , '  Commands'             , 'commands [?]'           },
      { '/',  builtin.search_history , '  Search history'       , '[/]search history'      },
    },

    v = {
      { 's',  custom.selection       ,  '' --[[dynamic]]          , 'visual [s]election'     },
    }
  })

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

