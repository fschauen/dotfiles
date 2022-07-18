local util = require 'fs.util'
local nmap = util.nmap
local imap = util.imap
local vmap = util.vmap

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

-- easy tab navigation
nmap { '<leader>.', '<cmd>tabnext<cr>',     { silent = true } }
nmap { '<leader>,', '<cmd>tabprevious<cr>', { silent = true } }

-- move lines up and down
nmap { '<c-a-j>',       [[:move .+1<cr>==]]    , { silent = true } }
nmap { '<c-a-k>',       [[:move .-2<cr>==]]    , { silent = true } }
vmap { '<c-a-j>',       [[:move '>+1<cr>gv=gv]], { silent = true } }
vmap { '<c-a-k>',       [[:move '<-2<cr>gv=gv]], { silent = true } }
imap { '<c-a-j>',  [[<esc>:move .+1<cr>==gi]]  , { silent = true } }
imap { '<c-a-k>',  [[<esc>:move .-2<cr>==gi]]  , { silent = true } }

-- move to begin/end of line in insert mode
imap { '<c-a>', '<c-o>^' }
imap { '<c-e>', '<c-o>$' }

-- navigate items in quickfix list
nmap { '<leader>j', '<cmd>cnext<cr>',     { silent = true } }
nmap { '<leader>k', '<cmd>cprevious<cr>', { silent = true } }

-- cycle through line numbering modes
nmap { '<leader>ln', '<cmd>set nonumber norelativenumber<CR>' , { silent = true } }
nmap { '<leader>ll', '<cmd>set number norelativenumber<CR>'   , { silent = true } }
nmap { '<leader>lr', '<cmd>set number relativenumber<CR>'     , { silent = true } }

-- show/hide listchars
nmap { '<leader>sl', '<cmd>set list!<CR>', { silent = true } }

-- quickly change background
nmap { '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]] }

-- disable highlight until next search
nmap { '<leader>h', '<cmd>nohlsearch<cr>' }

-- edit configuration files
nmap { '<leader>eg', '<cmd>tabedit ~/.config/git/config<cr>' }
nmap { '<leader>et', '<cmd>tabedit ~/.config/tmux/tmux.conf<cr>' }
nmap { '<leader>ev', '<cmd>tabedit ~/.config/nvim/init.lua<cr>' }
nmap { '<leader>es', '<cmd>tabedit ~/.config/nvim/spell/en.utf-8.add<cr>' }
nmap { '<leader>ez', '<cmd>tabedit ~/.config/zsh/.zshrc<cr>' }

