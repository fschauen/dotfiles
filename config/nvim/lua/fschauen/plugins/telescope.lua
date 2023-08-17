local M = { 'nvim-telescope/telescope.nvim' }

M.dependencies = {
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
          '&& cmake --build build --config Release ' ..
          '&& cmake --install build --prefix build',
}

M.cmd = 'Telescope'

local pick = require('fschauen.telescope').pickers
M.keys = {
  { '<leader>fa',  pick.autocommands           '  Autocommands'         , desc = ' Telescope [a]utocommands'            },
  { '<leader>fb',  pick.buffers                '  Buffers'              , desc = ' Telescope [b]uffers'                 },
  { '<leader>fc',  pick.colorscheme            '  Colorschemes'         , desc = ' Telescope [c]olorschemes'            },
  { '<leader>fdd', pick.diagnostics            '󰀪  Document Diagnostics' , desc = ' Telescope [d]iagnostics [d]ocument'  },
  { '<leader>fdw', pick.diagnostics            '󰀪  Workspace Diagnostics', desc = ' Telescope [d]iagnostics [w]orkspace' },
  --'<leader>fe'
  { '<leader>ff',  pick.find_files             '  Files'                , desc = ' Telescope [f]ind files'              },
  { '<leader>fF',  pick.all_files              '  ALL files'            , desc = ' Telescope all [F]iles'               },
  { '<leader>fgr', pick.live_grep              '  Live grep'            , desc = ' Telescope Live [gr]ep'               },
  { '<leader>fgf', pick.git_files              '  Git files'            , desc = ' Telescope [g]it [f]iles'             },
  { '<leader>fgc', pick.git_commits            ' Commits'             , desc = ' Telescope [g]it [c]ommits'           },
  { '<leader>fh',  pick.here                   '  Current buffer'       , desc = ' Telescope [b]uffer [h]ere'           },
  { '<leader>fH',  pick.highlights             '󰌶  Highlights'           , desc = ' Telescope [H]ighlights'              },
  --'<leader>fi'
  { '<leader>fj',  pick.jumplist               '  Jumplist'             , desc = ' Telescope [j]umplist'                },
  { '<leader>fk',  pick.keymaps                '  Keymaps'              , desc = ' Telescope [k]eymaps'                 },
  { '<leader>fK',  pick.help_tags              '  Help tags'            , desc = ' Telescope [K] help/documentation'    },
  { '<leader>fl',  pick.loclist                '  Location list'        , desc = ' Telescope [l]ocation List'           },
  { '<leader>fm',  pick.man_pages              '  Man pages'            , desc = ' Telescope [m]an pages'               },
  --'<leader>fn'
  { '<leader>fo',  pick.vim_options            '  Vim options'          , desc = ' Telescope vim [o]ptions'             },
  --'<leader>fp'
  { '<leader>fq',  pick.quickfix               '  Quickfix'             , desc = ' Telescope [q]uickfix'                },
  { '<leader>fr',  pick.lsp_references         '  References'           , desc = ' Telescope [r]eferences'              },
  { '<leader>fR',  pick.registers              '󱓥  Registers'            , desc = ' Telescope [R]registers'              },
  { '<leader>fs',  pick.lsp_document_symbols   '󰫧  Document Symbols '    , desc = ' Telescope lsp document [s]ymbols'    },
  { '<leader>fS',  pick.lsp_workspace_symbols  '󱄑  Workspace Symbols '   , desc = ' Telescope lsp workspace [S]ymbols'   },
  --'<leader>ft'   used in todo_comments
  { '<leader>fT',  pick.treesitter             '  Treesitter symbols'   , desc = ' Telescope [T]reesitter Symbols'      },
  --'<leader>fu'
  --'<leader>fv'
  { '<leader>fw',  pick.selection              '  Grep'                 , desc = ' Telescope [w]word under cursor'      },
  { '<leader>fw',  pick.selection              '  Grep',  mode = 'v'    , desc = ' Telescope [w]ord(s) selected'        },
  --'<leader>fx'
  --'<leader>fy'
  { '<leader>fz',  pick.spell_suggest          '󰓆  Spelling suggestions' , desc = ' Telescope [z] spell suggestions'     },
  { '<leader>f.',  pick.dotfiles               '  Dotfiles'             , desc = ' Telescope [.]dotfiles'               },
  { '<leader>f:',  pick.command_history        '  Command history'      , desc = ' Telescope [:]command history'        },
  { '<leader>f?',  pick.commands               '  Commands'             , desc = ' Telescope commands [?]'              },
  { '<leader>f/',  pick.search_history         '  Search history'       , desc = ' Telescope [/]search history'         },
  { '<leader>f<leader>', pick.resume           '󰐎  Resume'               , desc = ' Telescope Resume '                   },
}

M.opts = function()
  local actions = require('telescope.actions')
  local layout  = require('telescope.actions.layout')
  local trouble = vim.F.npcall(require, 'trouble.providers.telescope') or {}

  local mappings = {
    ['<c-j>']    = actions.cycle_history_next,
    ['<c-k>']    = actions.cycle_history_prev,
    ['<s-down>'] = actions.preview_scrolling_down,
    ['<s-up>']   = actions.preview_scrolling_up,
    ['<c-y>']    = layout.cycle_layout_next,
    ['<c-o>']    = layout.toggle_mirror,
    ['<c-c>']    = actions.close,
    ['<c-q>']    = actions.smart_send_to_qflist + actions.open_qflist,
    ['<c-l>']    = actions.smart_send_to_loclist + actions.open_loclist,
    ['<c-b>']    = trouble.smart_open_with_trouble,
  }

  return {
    defaults = {
      mappings = {
        i = mappings,
        n = mappings,
      },

      prompt_prefix = '   ',     -- Alternatives:   ❯
      selection_caret = ' ',     -- Alternatives:   ➔  

      multi_icon = '󰄬 ',          -- Alternatives: 󰄬    
      scroll_strategy = 'limit',  -- Don't wrap around in results.

      dynamic_preview_title = true,

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
    pickers = {
      buffers = {
        mappings = {
          n = {
            x = actions.delete_buffer,
          },
        },
      },
      colorscheme = {
        theme = 'dropdown',
      },
      spell_suggest = {
        theme = 'cursor',
      },
    },
    extensions = {
      file_browser = {
        theme = 'ivy'
      },
    },
  }
end

M.config = function(_, opts)
  require('telescope').setup(opts)
  require('telescope').load_extension 'fzf'

  vim.api.nvim_create_autocmd('User', {
    desc = 'Enable line number in Telescope previewers.',
    group = vim.api.nvim_create_augroup('fschauen.telescope', { clear = true } ),
    pattern = 'TelescopePreviewerLoaded',
    command = 'setlocal number'
  })
end

return M

