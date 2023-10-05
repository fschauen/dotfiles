local M = {}

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
  {     '*',     '*zzzv' },
  {     '#',     '#zzzv' },
  {    'g*',    'g*zzzv' },
  {    'g#',    'g#zzzv' },
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

  -- trigger InsertLeave when leaving Insert mode with ctrl-c (see :help i_CTRL-C)
  { '<c-c>', '<esc>', mode = 'i' },

  -- quickly change background
  { '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]] },

  -- navigate diagnostics
  { '<Down>',     diagnostic.goto_next },
  { '<Up>',       diagnostic.goto_prev },
  { '<leader>dd', diagnostic.toggle },
  { '<leader>do', diagnostic.open_float },
  { '<leader>dh', diagnostic.hide },
  { '<leader>dt', diagnostic.select_virtual_text_severity },

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

  -- quickly open lazy.nvim plugin manager
  { '<leader>L', '<cmd>Lazy<cr>' },

  -- toggle options
  { '<leader>sn', toggle_number },
  { '<leader>sr', toggle_relativenumber },
  { '<leader>sl', '<cmd>set list!  | set list?<CR>' },
  { '<leader>sw', '<cmd>set wrap!  | set wrap?<CR>' },
  { '<leader>ss', '<cmd>set spell! | set spell?<CR>' },
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

return M

