local M = { 'nvim-telescope/telescope.nvim' }

M.dependencies = {
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
          '&& cmake --build build --config Release ' ..
          '&& cmake --install build --prefix build',
}

M.cmd = 'Telescope'

local builtin_picker = function(name, opts)
  return function(title)
    return function()
      local picker = require('telescope.builtin')[name]
      picker(vim.tbl_extend('force', opts or {}, { prompt_title = title }))
    end
  end
end

local util = require('fschauen.util')
local icons = require('fschauen.util.icons')

local pickers = setmetatable({
  all_files = builtin_picker('find_files', {
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
  }),
  colorscheme = builtin_picker('colorscheme', {
    enable_preview = true,
  }),
  diagnostics = builtin_picker('diagnostics', {
    bufnr = 0
  }),
  dotfiles = builtin_picker('find_files', {
    cwd = '~/.dotfiles',
    hidden = true,
  }),
  selection = function(title)
    return function()
      local text = util.get_selected_text()
      return require('telescope.builtin').grep_string {
        prompt_title = string.format(title .. ': %s  ', text),
        search = text,
      }
    end
  end,
  here = builtin_picker('current_buffer_fuzzy_find'),
}, {
  -- Fall back to telescope's built-in pickers if a custom one is not defined
  -- above, but make sure to keep the title we defined.
  __index = function( --[[tbl]] _, key)
    return builtin_picker(key)
  end
})

M.keymap = {
  lhs = function(keys) return '<leader>f' .. keys end,
  description = function(text) return icons.ui.Telescope .. ' Telescope ' .. text end
}
local lhs, desc = M.keymap.lhs, M.keymap.description

M.keys = {
  { lhs'a',  pickers.autocommands           '  Autocommands'         , desc = desc('[a]utocommands')            },
  { lhs'b',  pickers.buffers                '  Buffers'              , desc = desc('[b]uffers')                 },
  --lhs'B'   used in telescope-file-browser
  { lhs'c',  pickers.colorscheme            '  Colorschemes'         , desc = desc('[c]olorschemes')            },
  { lhs'C',  pickers.commands               '  Commands'             , desc = desc('[C]ommands')                },
  { lhs'd',  pickers.diagnostics            '󰀪  Diagnostics'          , desc = desc('[d]iagnostics')             },
  --lhs'e'
  { lhs'f',  pickers.find_files             '  Files'                , desc = desc('[f]ind files')              },
  { lhs'F',  pickers.all_files              '  ALL files'            , desc = desc('all [F]iles')               },
  { lhs'gr', pickers.live_grep              '  Live grep'            , desc = desc('Live [gr]ep')               },
  { lhs'gf', pickers.git_files              '  Git files'            , desc = desc('[g]it [f]iles')             },
  { lhs'gc', pickers.git_commits            ' Commits'             , desc = desc('[g]it [c]ommits')           },
  { lhs'h',  pickers.here                   '  Current buffer'       , desc = desc('[b]uffer [h]ere')           },
  { lhs'H',  pickers.highlights             '󰌶  Highlights'           , desc = desc('[H]ighlights')              },
  --lhs'i'   used in nerdy
  { lhs'j',  pickers.jumplist               '  Jumplist'             , desc = desc('[j]umplist')                },
  { lhs'k',  pickers.keymaps                '  Keymaps'              , desc = desc('[k]eymaps')                 },
  { lhs'K',  pickers.help_tags              '  Help tags'            , desc = desc('[K] help/documentation')    },
  { lhs'l',  pickers.loclist                '  Location list'        , desc = desc('[l]ocation List')           },
  { lhs'm',  pickers.man_pages              '  Man pages'            , desc = desc('[m]an pages')               },
  --lhs'n'   used in vim-notify
  { lhs'o',  pickers.vim_options            '  Vim options'          , desc = desc('[o]ptions')                 },
  --lhs'p'
  { lhs'q',  pickers.quickfix               '  Quickfix'             , desc = desc('[q]uickfix')                },
  { lhs'r',  pickers.lsp_references         '  References'           , desc = desc('[r]eferences')              },
  { lhs'R',  pickers.registers              '󱓥  Registers'            , desc = desc('[R]registers')              },
  { lhs's',  pickers.lsp_document_symbols   '󰫧  Document Symbols '    , desc = desc('LSP document [s]ymbols')    },
  { lhs'S',  pickers.lsp_workspace_symbols  '󱄑  Workspace Symbols '   , desc = desc('LSP workspace [S]ymbols')   },
  --lhs't'   used in todo_comments
  { lhs'T',  pickers.treesitter             '  Treesitter symbols'   , desc = desc('[T]reesitter Symbols')      },
  --lhs'u'
  --lhs'v'
  { lhs'w',  pickers.selection              '  Grep'                 , desc = desc('[w]word under cursor')      },
  { lhs'w',  pickers.selection              '  Grep',  mode = 'v'    , desc = desc('[w]ord(s) selected')        },
  --lhs'x'
  --lhs'y'
  { lhs'z',  pickers.spell_suggest          '󰓆  Spelling suggestions' , desc = desc('[z] spell suggestions')     },
  { lhs'.',  pickers.dotfiles               '  Dotfiles'             , desc = desc('[.]dotfiles')               },
  { lhs':',  pickers.command_history        '  Command history'      , desc = desc('[:]command history')        },
  { lhs'/',  pickers.search_history         '  Search history'       , desc = desc('[/]search history')         },
  { lhs'<leader>', pickers.resume           '󰐎  Resume'               , desc = desc('Resume ')                   },
}

M.opts = function(--[[plugin]]_, opts)
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
    ['<c-h>']    = layout.toggle_preview,
    ['<c-s>']    = actions.select_horizontal,
    ['<c-x>']    = false,
    ['<c-c>']    = actions.close,
    ['<c-q>']    = actions.smart_send_to_qflist + actions.open_qflist,
    ['<c-l>']    = actions.smart_send_to_loclist + actions.open_loclist,
    ['<c-b>']    = trouble.smart_open_with_trouble,
  }

  return vim.tbl_deep_extend('force', opts or {}, {
    defaults = {
      mappings = { i = mappings, n = mappings },

      prompt_prefix = ' ' .. icons.ui.Telescope .. '  ',
      selection_caret = icons.ui.Play .. ' ',

      multi_icon = icons.ui.Checkbox .. ' ',
      scroll_strategy = 'limit',  -- Don't wrap around in results.

      dynamic_preview_title = true,

      layout_strategy = 'flex',
      layout_config = {
        width      = 0.9,
        height     = 0.9,
        flex       = { flip_columns   = 180 },
        horizontal = { preview_width  = 0.5 },
        vertical   = { preview_height = 0.5 },
      },
      cycle_layout_list = { 'horizontal', 'vertical' },
    },
    pickers = {
      buffers = {
        mappings = { n = { x = actions.delete_buffer } },
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
  })
end

M.config = function( --[[plugin]] _, opts)
  require('telescope').setup(opts)
  require('telescope').load_extension('fzf')
  vim.api.nvim_create_autocmd('User', {
    desc = 'Enable line number in Telescope previewers.',
    group = vim.api.nvim_create_augroup('fschauen.telescope', { clear = true }),
    pattern = 'TelescopePreviewerLoaded',
    command = 'setlocal number'
  })
end

return M

