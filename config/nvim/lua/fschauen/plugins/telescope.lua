local M = { 'nvim-telescope/telescope.nvim' }

M.dependencies = {
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
          '&& cmake --build build --config Release ' ..
          '&& cmake --install build --prefix build',
}

M.cmd = 'Telescope'

local builtin = function(picker, opts)
  return function(title)
    return function()
      local args = vim.tbl_extend('keep', { prompt_title = title }, opts or {})
      return require('telescope.builtin')[picker](args)
    end
  end
end

---Preserve register contents over function call.
---@param reg string: register to save, must be a valid register name.
---@param func function: function that may freely clobber the register.
---@return any: return value of calling `func`.
local with_saved_register = function(reg, func)
  local saved = vim.fn.getreg(reg)
  local result = func()
  vim.fn.setreg(reg, saved)
  return result
end

---Get selected text.
---@return string: selected text, or work under cursor if not in visual mode.
local get_selected_text = function()
  if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

  return with_saved_register('v', function()
    vim.cmd [[noautocmd sil norm "vy]]
    return vim.fn.getreg 'v'
  end)
end

local pickers = setmetatable({
  all_files = builtin('find_files', {
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
  }),
  colorscheme = builtin('colorscheme', {
    enable_preview = true,
  }),
  diagnostics = builtin('diagnostics', {
    bufnr = 0
  }),
  dotfiles = builtin('find_files', {
    cwd = '~/.dotfiles',
    hidden = true,
  }),
  selection = function(title)
    return function()
      local text = get_selected_text()
      return require('telescope.builtin').grep_string {
        prompt_title = string.format(title .. ': %s  ', text),
        search = text,
      }
    end
  end,
  here = builtin('current_buffer_fuzzy_find'),
}, {
  -- Fall back to telescope's built-in pickers if a custom one is not defined
  -- above, but make sure to keep the title we defined.
  __index = function(_, picker)
    return builtin(picker)
  end
})

local desc = function(text)
  return ' Telescope ' .. text
end

M.keys = {
  { '<leader>fa',  pickers.autocommands           '  Autocommands'         , desc = desc('[a]utocommands')            },
  { '<leader>fb',  pickers.buffers                '  Buffers'              , desc = desc('[b]uffers')                 },
  { '<leader>fc',  pickers.colorscheme            '  Colorschemes'         , desc = desc('[c]olorschemes')            },
  { '<leader>fC',  pickers.commands               '  Commands'             , desc = desc('[C]ommands')              },
  { '<leader>fdd', pickers.diagnostics            '󰀪  Document Diagnostics' , desc = desc('[d]iagnostics [d]ocument')  },
  { '<leader>fdw', pickers.diagnostics            '󰀪  Workspace Diagnostics', desc = desc('[d]iagnostics [w]orkspace') },
  --'<leader>fe'
  { '<leader>ff',  pickers.find_files             '  Files'                , desc = desc('[f]ind files')              },
  { '<leader>fF',  pickers.all_files              '  ALL files'            , desc = desc('all [F]iles')               },
  { '<leader>fgr', pickers.live_grep              '  Live grep'            , desc = desc('Live [gr]ep')               },
  { '<leader>fgf', pickers.git_files              '  Git files'            , desc = desc('[g]it [f]iles')             },
  { '<leader>fgc', pickers.git_commits            ' Commits'             , desc = desc('[g]it [c]ommits')           },
  { '<leader>fh',  pickers.here                   '  Current buffer'       , desc = desc('[b]uffer [h]ere')           },
  { '<leader>fH',  pickers.highlights             '󰌶  Highlights'           , desc = desc('[H]ighlights')              },
  --'<leader>fi'
  { '<leader>fj',  pickers.jumplist               '  Jumplist'             , desc = desc('[j]umplist')                },
  { '<leader>fk',  pickers.keymaps                '  Keymaps'              , desc = desc('[k]eymaps')                 },
  { '<leader>fK',  pickers.help_tags              '  Help tags'            , desc = desc('[K] help/documentation')    },
  { '<leader>fl',  pickers.loclist                '  Location list'        , desc = desc('[l]ocation List')           },
  { '<leader>fm',  pickers.man_pages              '  Man pages'            , desc = desc('[m]an pages')               },
  --'<leader>fn'
  { '<leader>fo',  pickers.vim_options            '  Vim options'          , desc = desc('vim [o]ptions')             },
  --'<leader>fp'
  { '<leader>fq',  pickers.quickfix               '  Quickfix'             , desc = desc('[q]uickfix')                },
  { '<leader>fr',  pickers.lsp_references         '  References'           , desc = desc('[r]eferences')              },
  { '<leader>fR',  pickers.registers              '󱓥  Registers'            , desc = desc('[R]registers')              },
  { '<leader>fs',  pickers.lsp_document_symbols   '󰫧  Document Symbols '    , desc = desc('lsp document [s]ymbols')    },
  { '<leader>fS',  pickers.lsp_workspace_symbols  '󱄑  Workspace Symbols '   , desc = desc('lsp workspace [S]ymbols')   },
  --'<leader>ft'   used in todo_comments
  { '<leader>fT',  pickers.treesitter             '  Treesitter symbols'   , desc = desc('[T]reesitter Symbols')      },
  --'<leader>fu'
  --'<leader>fv'
  { '<leader>fw',  pickers.selection              '  Grep'                 , desc = desc('[w]word under cursor')      },
  { '<leader>fw',  pickers.selection              '  Grep',  mode = 'v'    , desc = desc('[w]ord(s) selected')        },
  --'<leader>fx'
  --'<leader>fy'
  { '<leader>fz',  pickers.spell_suggest          '󰓆  Spelling suggestions' , desc = desc('[z] spell suggestions')     },
  { '<leader>f.',  pickers.dotfiles               '  Dotfiles'             , desc = desc('[.]dotfiles')               },
  { '<leader>f:',  pickers.command_history        '  Command history'      , desc = desc('[:]command history')        },
  { '<leader>f/',  pickers.search_history         '  Search history'       , desc = desc('[/]search history')         },
  { '<leader>f<leader>', pickers.resume           '󰐎  Resume'               , desc = desc('Resume ')                   },
}

local icons = require('fschauen.icons')

M.config = function()
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

  require('telescope').setup {
    defaults = {
      mappings = {
        i = mappings,
        n = mappings,
      },

      prompt_prefix = '   ',
      selection_caret = icons.ui.Play .. ' ',

      multi_icon = icons.ui.Checkbox,
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

  require('telescope').load_extension 'fzf'

  vim.api.nvim_create_autocmd('User', {
    desc = 'Enable line number in Telescope previewers.',
    group = vim.api.nvim_create_augroup('fschauen.telescope', { clear = true } ),
    pattern = 'TelescopePreviewerLoaded',
    command = 'setlocal number'
  })
end

return M

