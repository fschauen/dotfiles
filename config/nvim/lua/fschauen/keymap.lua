local diagnostic = require 'fschauen.diagnostic'
local window = require 'fschauen.window'

local toggle_number = function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = false
end

local toggle_relativenumber = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = vim.wo.relativenumber or vim.wo.number
end

M = {}

local base = {
  -- better navigation for wrapped lines
  { 'j', 'gj' },
  { 'k', 'gk' },

  -- maintain cursor position when joining lines
  { 'J', 'mzJ`z' },

  -- retain selection when making changes in visual mode
  {  '<c-a>',  '<c-a>gv', 'v' },
  {  '<c-x>',  '<c-x>gv', 'v' },
  { 'g<c-a>', 'g<c-a>gv', 'v' },
  { 'g<c-x>', 'g<c-x>gv', 'v' },
  {      '>',  '><cr>gv', 'v' },
  {      '<',  '<<cr>gv', 'v' },

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
  { '<c-a-j>', [[:move '>+1<cr>gv=gv]], 'v' },
  { '<c-a-k>', [[:move '<-2<cr>gv=gv]], 'v' },
  { '<c-a-j>', [[<esc>:move .+1<cr>==gi]], 'i' },
  { '<c-a-k>', [[<esc>:move .-2<cr>==gi]], 'i' },

  -- move to begin/end of line in insert mode
  { '<c-a>', '<c-o>^', 'i' },
  { '<c-e>', '<c-o>$', 'i' },

  -- move to begin of line in command mode (<c-e> moves to end by default)
  { '<c-a>', '<c-b>', 'c' },

  -- navigate items in quickfix and location lists
  {      '<leader>j', '<cmd>cnext<cr>zz' },
  {      '<leader>k', '<cmd>cprevious<cr>zz' },
  { '<localleader>j', '<cmd>lnext<cr>zz' },
  { '<localleader>k', '<cmd>lprevious<cr>zz' },

  -- navigate diagnostics
  { '<leader>dj', diagnostic.goto_next },
  { '<leader>dk', diagnostic.goto_prev },
  { '<leader>dd', diagnostic.toggle },
  { '<leader>do', diagnostic.open_float },
  { '<leader>dh', diagnostic.hide },

  -- toggle quickfix and loclist
  {      '<leader>ll', window.toggle_quickfix,  desc = 'Toggle quickfix'  },
  { '<localleader>ll', window.toggle_loclist,   desc = 'Toggle loclist'   },

  -- quickly open lazy.nvim plugin manager
  { '<leader>L', '<cmd>Lazy<cr>' },

  -- toggle options
  { '<leader>sn', toggle_number },
  { '<leader>sr', toggle_relativenumber },
  { '<leader>sl', '<cmd>set list!  | set list?<CR>' },
  { '<leader>sw', '<cmd>set wrap!  | set wrap?<CR>' },
  { '<leader>ss', '<cmd>set spell! | set spell?<CR>' },

  -- quickly change background
  { '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]] },

  -- disable highlight until next search
  { '<leader>h', '<cmd>nohlsearch<cr><esc>' },

  -- more convenient way of entering normal mode from terminal mode
  { [[<c-\><c-\>]], [[<c-\><c-n>]], 't' },

  -- recall older/recent command-line from history
  { '<c-j>', '<down>', 'c' },
  { '<c-k>', '<up>',   'c' },
}

local keymap_set = vim.keymap.set
local map = function(opts)
  local lhs, rhs, mode = opts[1], opts[2], opts[3] or 'n'
  opts[1], opts[2], opts[3], opts.mode = nil, nil, nil, nil
  opts.silent = opts.silent ~= false
  keymap_set(mode, lhs, rhs, opts)
end

M.setup = function()
  vim.tbl_map(map, base)
end

return M

