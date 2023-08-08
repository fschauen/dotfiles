return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
              '&& cmake --build build --config Release ' ..
              '&& cmake --install build --prefix build'
    },
  },

  config = function()
    local telescope      = require 'telescope'
    local actions        = require 'telescope.actions'
    local actions_layout = require 'telescope.actions.layout'

    local mappings = {
      ['<c-y>'] = actions_layout.cycle_layout_next,
      ['<c-o>'] = actions_layout.toggle_mirror,
      ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
      ['<c-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
      ['<c-c>'] = actions.close,

      ['<s-down>'] = actions.preview_scrolling_down,
      ['<s-up>']   = actions.preview_scrolling_up,

      ['<c-j>'] = actions.cycle_history_next,
      ['<c-k>'] = actions.cycle_history_prev,
    }

    local trouble = vim.F.npcall(require, 'trouble.providers.telescope')
    if trouble then
      mappings['<c-b>'] = trouble.open_with_trouble
    end

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
    local ts = require 'telescope.builtin'
    local my = {
      all_files = function(opts)
        ts.find_files(vim.tbl_extend('keep', opts or {}, {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        }))
      end,
      colorschemes = function(opts)
        ts.colorscheme(themes.get_dropdown(vim.tbl_extend('keep', opts or {}, {
          enable_preview = true,
        })))
      end,
      diagnostics = function(opts)
        ts.diagnostics(vim.tbl_extend('keep', opts or {}, { bufnr = 0 }))
      end,
      dotfiles = function(opts)
        ts.find_files(vim.tbl_extend('keep', opts or {}, {
          cwd = '~/.dotfiles',
          hidden = true,
        }))
      end,
      selection = function(_)
        local selected = require('fschauen.util').get_selected_text()
        ts.grep_string {
          prompt_title = string.format('    Grep: %s   ', selected),
          search = selected,
        }
      end,
      spell_suggest = function(opts)
        ts.spell_suggest(themes.get_cursor(opts))
      end,
      here = function(opts)
        ts.current_buffer_fuzzy_find(opts)
      end,
    }

    local map = function(keymap)
      for mode, list in pairs(keymap) do
        for _, row in ipairs(list) do
          local lhs, picker, title, desc = row[1], row[2], row[3], row[4]
          local rhs = function() picker { prompt_title = ' ' .. title .. ' ' } end
          vim.keymap.set(mode, '<leader>f' .. lhs, rhs, { desc = '  ' .. desc })
        end
      end
    end

    map {
      -- ╭────╮     ╭──────╮               ╭────────────╮              ╭───────────────────╮
      -- │keys│     │picker│               │prompt title│              │mapping description│
      -- ╰────╯     ╰──────╯               ╰────────────╯              ╰───────────────────╯
      n = {
        { 'a',  ts.autocommands          , '  Autocommands'         , '[a]utocommands'         },
        { 'b',  ts.buffers               , '  Buffers'              , '[b]uffers'              },
        { 'c',  my.colorschemes          , '  Colorschemes'         , '[c]olorschemes'         },
        { 'dd', my.diagnostics           , '󰀪  Document Diagnostics' , '[d]iagnostics [d]ocument' },
        { 'dw', ts.diagnostics           , '󰀪  Workspace Diagnostics', '[d]iagnostics [w]orkspace' },
        -- e
        { 'f',  ts.find_files            , '  Files'                , '[f]ind files'           },
        { 'F',  my.all_files             , '  ALL files'            , 'all [F]iles'            },
        { 'gr', ts.live_grep             , '  Live grep'            , 'Live [gr]ep'            },
        { 'gf', ts.git_files             , '  Git files'            , '[g]it [f]iles'          },
        { 'gc', ts.git_commits           , ' Commits'             , '[g]it [c]ommits'        },
        { 'h',  my.here                  , '  Current buffer'       , '[b]uffer [h]ere'        },
        { 'H',  ts.highlights            , '󰌶  Highlights'           , '[H]ighlights'           },
        -- i
        { 'j',  ts.jumplist              , '  Jumplist'             , '[j]umplist'             },
        { 'k',  ts.keymaps               , '  Keymaps'              , '[k]eymaps'              },
        { 'K',  ts.help_tags             , '  Help tags'            , '[K] help/documentation' },
        { 'l',  ts.loclist               , '  Location list'        , '[l]ocation List'        },
        { 'm',  ts.man_pages             , '  Man pages'            , '[m]an pages'            },
        -- n
        { 'o',  ts.vim_options           , '  Vim options'          , 'vim [o]ptions'          },
        -- p
        { 'q',  ts.quickfix              , '  Quickfix'             , '[q]uickfix'             },
        { 'r',  ts.lsp_references        , '  References'           , '[r]eferences'           },
        { 'R',  ts.registers             , '󱓥  Registers'            , '[R]registers'           },
        { 's',  ts.lsp_document_symbols  , '󰫧  Document Symbols '    , 'lsp document [s]ymbols' },
        { 'S',  ts.lsp_workspace_symbols , '󱄑  Workspace Symbols '   , 'lsp workspace [S]ymbols' },
        --'t'   used in todo-comments
        { 'T',  ts.treesitter            , '  Treesitter symbols'   , '[T]reesitter Symbols'   },
        -- u
        -- v
        { 'w',  my.selection             , '' --[[dynamic]]          , '[w]word under cursor'   },
        -- x
        -- y
        { 'z',  my.spell_suggest         , '󰓆  Spelling suggestions' , '[z] spell suggestions'  },
        { '.',  my.dotfiles              , '  Dotfiles'             , '[.]dotfiles'            },
        { ':',  ts.command_history       , '  Command history'      , '[:]command history'     },
        { '?',  ts.commands              , '  Commands'             , 'commands [?]'           },
        { '/',  ts.search_history        , '  Search history'       , '[/]search history'      },
        {'<leader>', ts.resume           , '󰐎  Resume'               , 'Resume'                 },
      },
      v = {
        { 's',  my.selection       ,  '' --[[dynamic]]          , 'visual [s]election'     },
      }
    }

    telescope.load_extension 'fzf'
    telescope.load_extension 'file_browser'
    vim.keymap.set('n', '<leader>fB', '<cmd>Telescope file_browser<cr>', { desc = ' [f]ile [B]rowser' })
  end,
}

