local prefix = require('fschauen.telescope').prefix
local pickers = require('fschauen.telescope').pickers
local actions = require('fschauen.telescope').actions

local mappings = {
  ['<c-j>']    = actions.cycle_history_next,
  ['<c-k>']    = actions.cycle_history_prev,
  ['<s-down>'] = actions.preview_scrolling_down,
  ['<s-up>']   = actions.preview_scrolling_up,
  ['<c-y>']    = actions.cycle_layout_next,
  ['<c-o>']    = actions.toggle_mirror,
  ['<c-c>']    = actions.close,
  ['<c-q>']    = actions.smart_send_to_qflist_and_open,
  ['<c-l>']    = actions.smart_send_to_loclist_and_open,
  ['<c-b>']    = actions.smart_open_with_trouble
}

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
  lazy = true,
  cmd = 'Telescope',
  opts  = {
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
  },
  keys = {
    { prefix .. 'a',  pickers.autocommands           ('  Autocommands'         ), { desc = ' [a]utocommands'            }},
    { prefix .. 'b',  pickers.buffers                ('  Buffers'              ), { desc = ' [b]uffers'                 }},
    { prefix .. 'B', '<cmd>Telescope file_browser<cr>'                           , { desc = ' file [B]rowser'            }},
    { prefix .. 'c',  pickers.colorscheme            ('  Colorschemes'         ), { desc = ' [c]olorschemes'            }},
    { prefix .. 'dd', pickers.diagnostics            ('󰀪  Document Diagnostics' ), { desc = ' [d]iagnostics [d]ocument'  }},
    { prefix .. 'dw', pickers.diagnostics            ('󰀪  Workspace Diagnostics'), { desc = ' [d]iagnostics [w]orkspace' }},
    --          'e'
    { prefix .. 'f',  pickers.find_files             ('  Files'                ), { desc = ' [f]ind files'              }},
    { prefix .. 'F',  pickers.all_files              ('  ALL files'            ), { desc = ' all [F]iles'               }},
    { prefix .. 'gr', pickers.live_grep              ('  Live grep'            ), { desc = ' Live [gr]ep'               }},
    { prefix .. 'gf', pickers.git_files              ('  Git files'            ), { desc = ' [g]it [f]iles'             }},
    { prefix .. 'gc', pickers.git_commits            (' Commits'             ), { desc = ' [g]it [c]ommits'           }},
    { prefix .. 'h',  pickers.here                   ('  Current buffer'       ), { desc = ' [b]uffer [h]ere'           }},
    { prefix .. 'H',  pickers.highlights             ('󰌶  Highlights'           ), { desc = ' [H]ighlights'              }},
    --          'i'
    { prefix .. 'j',  pickers.jumplist               ('  Jumplist'             ), { desc = ' [j]umplist'                }},
    { prefix .. 'k',  pickers.keymaps                ('  Keymaps'              ), { desc = ' [k]eymaps'                 }},
    { prefix .. 'K',  pickers.help_tags              ('  Help tags'            ), { desc = ' [K] help/documentation'    }},
    { prefix .. 'l',  pickers.loclist                ('  Location list'        ), { desc = ' [l]ocation List'           }},
    { prefix .. 'm',  pickers.man_pages              ('  Man pages'            ), { desc = ' [m]an pages'               }},
    --          'n'
    { prefix .. 'o',  pickers.vim_options            ('  Vim options'          ), { desc = ' vim [o]ptions'             }},
    --          'p'
    { prefix .. 'q',  pickers.quickfix               ('  Quickfix'             ), { desc = ' [q]uickfix'                }},
    { prefix .. 'r',  pickers.lsp_references         ('  References'           ), { desc = ' [r]eferences'              }},
    { prefix .. 'R',  pickers.registers              ('󱓥  Registers'            ), { desc = ' [R]registers'              }},
    { prefix .. 's',  pickers.lsp_document_symbols   ('󰫧  Document Symbols '    ), { desc = ' lsp document [s]ymbols'    }},
    { prefix .. 'S',  pickers.lsp_workspace_symbols  ('󱄑  Workspace Symbols '   ), { desc = ' lsp workspace [S]ymbols'   }},
    --          't'   used in todo-commenpickers
    { prefix .. 'T',  pickers.treesitter             ('  Treesitter symbols'   ), { desc = ' [T]reesitter Symbols'      }},
    --          'u'
    --          'v'
    { prefix .. 'w',  pickers.selection              (--[[dynamic]])             , { desc = ' [w]word under cursor'      }},
    { prefix .. 'w',  pickers.selection              (--[[dynamic]]), mode = 'v' , { desc = ' visual [s]election'        }},
    --          'x'
    --          'y'
    { prefix .. 'z',  pickers.spell_suggest          ('󰓆  Spelling suggestions') , { desc = ' [z] spell suggestions'     }},
    { prefix .. '.',  pickers.dotfiles               ('  Dotfiles'            ) , { desc = ' [.]dotfiles'               }},
    { prefix .. ':',  pickers.command_history        ('  Command history'     ) , { desc = ' [:]command history'        }},
    { prefix .. '?',  pickers.commands               ('  Commands'            ) , { desc = ' commands [?]'              }},
    { prefix .. '/',  pickers.search_history         ('  Search history'      ) , { desc = ' [/]search history'         }},
    { prefix .. '<leader>', pickers.resume           ('󰐎  Resume'              ) , { desc = ' Resume '                   }},
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension 'fzf'
    require('telescope').load_extension 'file_browser'
  end
}

