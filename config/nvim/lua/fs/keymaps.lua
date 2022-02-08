local keymap = require 'fs.util.keymap'
local nmap = keymap.nmap
local imap = keymap.imap
local vmap = keymap.vmap

vim.g.mapleader = ' '

-- better navigation for wrapped lines
nmap { 'j', 'gj' }
nmap { 'k', 'gk' }

-- retain selection when indenting/unindenting in visual mode
vmap { '>', '><cr>gv' }
vmap { '<', '<<cr>gv' }

-- easier window navigation
nmap { '<c-j>', '<c-w>j' }
nmap { '<c-k>', '<c-w>k' }
nmap { '<c-h>', '<c-w>h' }
nmap { '<c-l>', '<c-w>l' }

-- window resizing
nmap { '<Up>',    '<cmd>resize +1<cr>' }
nmap { '<Down>',  '<cmd>resize -1<cr>' }
nmap { '<Left>',  '<cmd>vertical resize -1<cr>' }
nmap { '<Right>', '<cmd>vertical resize +1<cr>' }

-- easier tab navigation
nmap { '<c-n>', '<cmd>tabprevious<cr>', { silent = true } }
nmap { '<c-m>', '<cmd>tabnext<cr>'    , { silent = true } }

-- move lines up and down
nmap { '<A-j>',       [[:move .+1<cr>==]]    , { silent = true } }
nmap { '<A-k>',       [[:move .-2<cr>==]]    , { silent = true } }
vmap { '<A-j>',       [[:move '>+1<cr>gv=gv]], { silent = true } }
vmap { '<A-k>',       [[:move '<-2<cr>gv=gv]], { silent = true } }
imap { '<A-j>',  [[<esc>:move .+1<cr>==gi]]  , { silent = true } }
imap { '<A-k>',  [[<esc>:move .-2<cr>==gi]]  , { silent = true } }

-- move to begin/end of line in insert mode
imap { '<c-a>', '<c-o>^' }
imap { '<c-e>', '<c-o>$' }

-- cycle through line numbering modes
nmap { '<leader>ln', '<cmd>set nonumber norelativenumber<CR>' , { silent = true } }
nmap { '<leader>ll', '<cmd>set number norelativenumber<CR>'   , { silent = true } }
nmap { '<leader>lr', '<cmd>set number relativenumber<CR>'     , { silent = true } }

-- show list of buffers and prepare to switch
nmap { '<leader>bf', '<cmd>ls<CR>:b<Space>' }

-- quickly change background
nmap { '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]] }

-- disable highlight until next search
nmap { '<leader>h', '<cmd>nohlsearch<cr>' }

-- edit configuration files
nmap { '<leader>eg', '<cmd>tabedit ~/.config/git/config<cr>' }
nmap { '<leader>et', '<cmd>tabedit ~/.config/tmux/tmux.conf<cr>' }
nmap { '<leader>ev', '<cmd>tabedit ~/.config/nvim/init.lua<cr>' }
nmap { '<leader>ez', '<cmd>tabedit ~/.config/zsh/.zshrc<cr>' }

