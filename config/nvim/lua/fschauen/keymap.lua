local M = {}

local diagnostic = require 'fschauen.diagnostic'
local window = require 'fschauen.window'
local pick = require('fschauen.telescope').pickers
local completion = require 'fschauen.completion'

local toggle_number = function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = false
end

local toggle_relativenumber = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = vim.wo.relativenumber or vim.wo.number
end

local toggle_colorcolumn = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'  -- one after 'textwidth'
  else
    vim.o.colorcolumn = ''    -- none
  end
end

local keymap = {
  -- better navigation for wrapped lines
    { 'j', 'gj' },
    { 'k', 'gk' },

  -- maintain cursor position when joining lines
    { 'J', 'mzJ`z' },

  -- retain selection when making changes in visual mode
    {  '<c-a>',  '<c-a>gv', mode = 'v' },
    {  '<c-x>',  '<c-x>gv', mode = 'v' },
    { 'g<c-a>', 'g<c-a>gv', mode = 'v' },
    { 'g<c-x>', 'g<c-x>gv', mode = 'v' },
    {      '>',  '><cr>gv', mode = 'v' },
    {      '<',  '<<cr>gv', mode = 'v' },

  -- place destination of important movements in the center of the screen
    {     'n',     'nzzzv' },
    {     'N',     'Nzzzv' },
    { '<c-d>', '<c-d>zzzv' },
    { '<c-u>', '<c-u>zzzv' },

  -- easier window navigation
    { '<c-j>', '<c-w>j' },
    { '<c-k>', '<c-w>k' },
    { '<c-h>', '<c-w>h' },
    { '<c-l>', '<c-w>l' },

  -- window resizing
    {    '<s-Up>',    window.resize_up(2), desc = 'Resize window upward'    },
    {  '<s-Down>',  window.resize_down(2), desc = 'Resize window downward'  },
    {  '<s-Left>',  window.resize_left(2), desc = 'Resize window leftward'  },
    { '<s-Right>', window.resize_right(2), desc = 'Resize window rightward' },

  -- easy tab navigation
    { '<Right>', '<cmd>tabnext<cr>' },
    {  '<Left>', '<cmd>tabprevious<cr>' },

  -- move lines up and down
    { '<c-a-j>', [[:move .+1<cr>==]] },
    { '<c-a-k>', [[:move .-2<cr>==]] },
    { '<c-a-j>', [[:move '>+1<cr>gv=gv]],     mode = 'v' },
    { '<c-a-k>', [[:move '<-2<cr>gv=gv]],     mode = 'v' },
    { '<c-a-j>', [[<esc>:move .+1<cr>==gi]],  mode = 'i' },
    { '<c-a-k>', [[<esc>:move .-2<cr>==gi]],  mode = 'i' },

  -- move to begin/end of line in insert mode
    { '<c-a>', '<c-o>^', mode = 'i' },
    { '<c-e>', '<c-o>$', mode = 'i' },

  -- move to begin of line in command mode (<c-e> moves to end by default)
    { '<c-a>', '<c-b>', mode = 'c' },

  -- more convenient way of entering normal mode from terminal mode
    { [[<c-\><c-\>]], [[<c-\><c-n>]], mode = 't' },

  -- recall older/recent command-line from history
    { '<c-j>', '<down>', mode = 'c' },
    { '<c-k>', '<up>',   mode = 'c' },

  completion = {
    {'<c-n>'    , completion.select_next_or_complete,  mode = { 'i', 'c' }, desc = '󰁨 Complete: select next'},
    {'<c-p>'    , completion.select_prev_or_complete,  mode = { 'i', 'c' }, desc = '󰁨 Complete: select previous'},
    {'<down>'   , completion.select_next_item,         mode = { 'i', 'c' }, desc = '󰁨 Complete: select next'},
    {'<up>'     , completion.select_prev_item,         mode = { 'i', 'c' }, desc = '󰁨 Complete: select previous'},

    {'<c-f>'    , completion.scroll_docs(-3),          mode = { 'i', 'c' }, desc = '󰁨 Complete: scroll docs down'},
    {'<s-down>' , completion.scroll_docs(-3),          mode = { 'i', 'c' }, desc = '󰁨 Complete: scroll docs down'},
    {'<c-b>'    , completion.scroll_docs( 3),          mode = { 'i', 'c' }, desc = '󰁨 Complete: scroll docs up'},
    {'<s-up>'   , completion.scroll_docs( 3),          mode = { 'i', 'c' }, desc = '󰁨 Complete: scroll docs up'},

    {'<c-e>'    , completion.abort,                    mode = { 'i', 'c' }, desc = '󰁨 Complete: abort'},
    {'<c-y>'    , completion.confirm,                  mode = { 'i', 'c' }, desc = '󰁨 Complete: confirm'},
  },

  -- quickly change background
    { '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]] },

  -- navigate diagnostics
    { '<leader>dj', diagnostic.goto_next },
    { '<leader>dk', diagnostic.goto_prev },
    { '<leader>dd', diagnostic.toggle },
    { '<leader>do', diagnostic.open_float },
    { '<leader>dh', diagnostic.hide },

  telescope_file_browser = {
    { '<leader>fB', '<cmd>Telescope file_browser<cr>' , desc = ' file [B]rowser' },
  },

  telescope = {
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
    --'<leader>ft'   used in todo_comments below
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
  },

  todo_comments = {
    { '<leader>ft', '<cmd>TodoTelescope<cr>' },
  },

  fugitive = {
    { '<leader>gg', ':Git ' },
    { '<leader>gs', '<cmd>tab Git<cr>' },
    { '<leader>gb', '<cmd>Git blame<cr>' }
  },

  neogit = {
    { '<leader>gn', '<cmd>Neogit<cr>' },
  },

  -- disable highlight until next search
    { '<leader>h', '<cmd>nohlsearch<cr><esc>' },

  -- navigate items in quickfix and location lists
    {      '<leader>j', '<cmd>cnext<cr>zz' },
    {      '<leader>k', '<cmd>cprevious<cr>zz' },
    { '<localleader>j', '<cmd>lnext<cr>zz' },
    { '<localleader>k', '<cmd>lprevious<cr>zz' },

  -- toggle quickfix and loclist
    {      '<leader>ll', window.toggle_quickfix,  desc = 'Toggle quickfix'  },
    { '<localleader>ll', window.toggle_loclist,   desc = 'Toggle loclist'   },

  trouble = {
    { '<leader>lt', '<cmd>TroubleToggle<cr>' },
    { '<leader>lw', '<cmd>TroubleToggle workspace_diagnostics<cr>' },
    { '<leader>ld', '<cmd>TroubleToggle document_diagnostics<cr>' },
  },

  -- quickly open lazy.nvim plugin manager
    { '<leader>L', '<cmd>Lazy<cr>' },

  nvim_tree = {
    { '<leader>nn', '<cmd>NvimTreeOpen<cr>' },
    { '<leader>nf', '<cmd>NvimTreeFindFile<cr>' },
    { '<leader>nc', '<cmd>NvimTreeClose<cr>' },
  },

  -- toggle options
    { '<leader>sn', toggle_number },
    { '<leader>sr', toggle_relativenumber },
    { '<leader>sl', '<cmd>set list!  | set list?<CR>' },
    { '<leader>sw', '<cmd>set wrap!  | set wrap?<CR>' },
    { '<leader>ss', '<cmd>set spell! | set spell?<CR>' },

  virt_column = {
    { '<leader>sc', toggle_colorcolumn, desc = 'Toggle virtual colunn' },
  },

  indent_blankline = {
    { '<leader>si', '<cmd>IndentBlanklineToggle<cr>' },
  },

  treesitter = {
    { '<leader>tp', '<cmd>TSPlaygroundToggle<cr>' },
    { '<leader>th', '<cmd>TSHighlightCapturesUnderCursor<cr>' },
    { '<leader>tn', '<cmd>TSNodeUnderCursor<cr>' },
  },

  undotree = {
    { '<leader>u', '<cmd>UndotreeToggle<cr>' },
  },

  whitespace ={
    { '<leader>ww', '<cmd>ToggleWhitespace<cr>' },
    { '<leader>wj', '<cmd>NextTrailingWhitespace<cr>' },
    { '<leader>wk', '<cmd>PrevTrailingWhitespace<cr>' },
    { '<leader>wd', '<cmd>StripWhitespace<cr>' },
  },
}

M.setup = function()
  local set = vim.keymap.set

  for _, map in ipairs(keymap) do
    local lhs, rhs, mode = map[1], map[2], map.mode or 'n'
    map[1], map[2], map.mode = nil, nil, nil
    map.silent = map.silent ~= false  -- silent by default
    set(mode, lhs, rhs, map)
  end
end

setmetatable(M, {
  __index = function (_, k)
   return keymap[k]
  end
})

return M

