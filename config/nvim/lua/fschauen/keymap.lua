local M = {}

local map = function(mode, lhs, rhs, opts)
  if mode ~= 'c' then
    opts = opts or {}
    opts.silent = opts.silent ~= false  -- silent by default
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.setup = function()
  -- better navigation for wrapped lines
  map('n', 'j', 'gj')
  map('n', 'k', 'gk')

  -- maintain cursor position when joining lines
  map('n', 'J', 'mzJ`z')

  -- retain selection when making changes in visual mode
  map('v',  '<c-a>',  '<c-a>gv')
  map('v',  '<c-x>',  '<c-x>gv')
  map('v', 'g<c-a>', 'g<c-a>gv')
  map('v', 'g<c-x>', 'g<c-x>gv')
  map('v',      '>',  '><cr>gv')
  map('v',      '<',  '<<cr>gv')

  -- place destination of important movements in the center of the screen
  map('n',     'n',     'nzzzv')
  map('n',     'N',     'Nzzzv')
  map('n',     '*',     '*zzzv')
  map('n',     '#',     '#zzzv')
  map('n',    'g*',    'g*zzzv')
  map('n',    'g#',    'g#zzzv')
  map('n', '<c-d>', '<c-d>zzzv')
  map('n', '<c-u>', '<c-u>zzzv')

  -- easier window navigation
  map('n', '<c-j>', '<c-w>j')
  map('n', '<c-k>', '<c-w>k')
  map('n', '<c-h>', '<c-w>h')
  map('n', '<c-l>', '<c-w>l')

  local window = require 'fschauen.window'

  -- window resizing
  map('n',    '<s-Up>',    window.resize_up(2), { desc = 'Resize window upward'    })
  map('n',  '<s-Down>',  window.resize_down(2), { desc = 'Resize window downward'  })
  map('n',  '<s-Left>',  window.resize_left(2), { desc = 'Resize window leftward'  })
  map('n', '<s-Right>', window.resize_right(2), { desc = 'Resize window rightward' })

  -- easy tab navigation
  map('n', '<Right>', '<cmd>tabnext<cr>')
  map('n',  '<Left>', '<cmd>tabprevious<cr>')

  -- move lines up and down
  map('n', '<c-a-j>', [[:move .+1<cr>==]])
  map('n', '<c-a-k>', [[:move .-2<cr>==]])
  map('v', '<c-a-j>', [[:move '>+1<cr>gv=gv]])
  map('v', '<c-a-k>', [[:move '<-2<cr>gv=gv]])
  map('i', '<c-a-j>', [[<esc>:move .+1<cr>==gi]])
  map('i', '<c-a-k>', [[<esc>:move .-2<cr>==gi]])

  -- move to begin/end of line in insert mode
  map('i', '<c-a>', '<c-o>^')
  map('i', '<c-e>', '<c-o>$')

  -- move to begin of line in command mode (<c-e> moves to end by default)
  map('c', '<c-a>', '<c-b>')

  -- more convenient way of entering normal mode from terminal mode
  map('t', [[<c-\><c-\>]], [[<c-\><c-n>]])

  -- recall older/recent command-line from history
  map('c', '<c-j>', '<down>')
  map('c', '<c-k>', '<up>')

  -- trigger InsertLeave when leaving Insert mode with ctrl-c (see :help i_CTRL-C)
  map('i', '<c-c>', '<esc>')

  -- quickly change background
  map('n', '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]])

  local diagnostic = require 'fschauen.diagnostic'

  -- navigate diagnostics
  map('n', '<Down>',     diagnostic.goto_next)
  map('n', '<Up>',       diagnostic.goto_prev)
  map('n', '<leader>dd', diagnostic.toggle)
  map('n', '<leader>do', diagnostic.open_float)
  map('n', '<leader>dh', diagnostic.hide)
  map('n', '<leader>dt', diagnostic.select_virtual_text_severity)

  -- disable highlight until next search
  map('n', '<leader>h', '<cmd>nohlsearch<cr><esc>')

  -- navigate items in quickfix and location lists
  map('n',      '<leader>j', '<cmd>cnext<cr>zz')
  map('n',      '<leader>k', '<cmd>cprevious<cr>zz')
  map('n', '<localleader>j', '<cmd>lnext<cr>zz')
  map('n', '<localleader>k', '<cmd>lprevious<cr>zz')

  local toggle = require('fschauen.util.icons').ui.Toggle .. '  toggle '

  -- toggle quickfix and loclist
  map('n',      '<leader>ll', window.toggle_quickfix, { desc = toggle .. 'quickfix' })
  map('n', '<localleader>ll', window.toggle_loclist,  { desc = toggle .. 'loclist'  })

  local options = require('fschauen.util.options')

  -- toggle options
  map('n', '<leader>sn', options.toggle_number,         { desc = toggle .. "'number'" })
  map('n', '<leader>sr', options.toggle_relativenumber, { desc = toggle .. "'relativenumber'" })
  map('n', '<leader>sl', options.toggle_list,           { desc = toggle .. "'list'" })
  map('n', '<leader>sw', options.toggle_wrap,           { desc = toggle .. "'wrap'" })
  map('n', '<leader>ss', options.toggle_spell,          { desc = toggle .. "'spell'" })
end

return M

