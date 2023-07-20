local partial = require('user.util').partial
local nmap = partial(vim.keymap.set, 'n')
local imap = partial(vim.keymap.set, 'i')
local vmap = partial(vim.keymap.set, 'v')
local cmap = partial(vim.keymap.set, 'c')
local tmap = partial(vim.keymap.set, 't')

-- better navigation for wrapped lines
nmap('j', 'gj')
nmap('k', 'gk')

-- maintain cursor position when joining lines
nmap('J', 'mzJ`z')

-- retain selection when indenting/unindenting in visual mode
vmap('>', '><cr>gv')
vmap('<', '<<cr>gv')

-- place next/previous search result in center of screen
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

-- select all
nmap('<c-a>', 'gg<s-v>G')

-- easier window navigation
nmap('<c-j>', '<c-w>j')
nmap('<c-k>', '<c-w>k')
nmap('<c-h>', '<c-w>h')
nmap('<c-l>', '<c-w>l')

-- window resizing
nmap('<s-Up>', '<cmd>resize +1<cr>')
nmap('<s-Down>', '<cmd>resize -1<cr>')
nmap('<s-Left>', '<cmd>vertical resize -1<cr>')
nmap('<s-Right>', '<cmd>vertical resize +1<cr>')

-- easy tab navigation
nmap('<Right>', '<cmd>tabnext<cr>', { silent = true })
nmap('<Left>', '<cmd>tabprevious<cr>', { silent = true })

-- move lines up and down
nmap('<c-a-j>', [[:move .+1<cr>==]], { silent = true })
nmap('<c-a-k>', [[:move .-2<cr>==]], { silent = true })
vmap('<c-a-j>', [[:move '>+1<cr>gv=gv]], { silent = true })
vmap('<c-a-k>', [[:move '<-2<cr>gv=gv]], { silent = true })
imap('<c-a-j>', [[<esc>:move .+1<cr>==gi]], { silent = true })
imap('<c-a-k>', [[<esc>:move .-2<cr>==gi]], { silent = true })

-- move to begin/end of line in insert mode
imap('<c-a>', '<c-o>^')
imap('<c-e>', '<c-o>$')

-- move to begin of line in command mode (<c-e> moves to end by default)
cmap('<c-a>', '<c-b>')

-- navigate items in quickfix list
nmap('<Down>', '<cmd>cnext<cr>zz', { silent = true })
nmap('<Up>', '<cmd>cprevious<cr>zz', { silent = true })

-- cycle through line numbering modes
nmap('<leader>ln', '<cmd>set nonumber norelativenumber<CR>', { silent = true })
nmap('<leader>ll', '<cmd>set number norelativenumber<CR>', { silent = true })
nmap('<leader>lr', '<cmd>set number relativenumber<CR>', { silent = true })

-- quickly open lazy.nvim plugin manager
nmap('<leader>L', '<cmd>Lazy<cr>')

-- toggle options
nmap('<leader>sl', '<cmd>set list! | set list?<CR>', { silent = true })
nmap('<leader>sr', '<cmd>set wrap! | set wrap?<CR>', { silent = true })
nmap('<leader>sp', '<cmd>set spell! | set spell?<CR>', { silent = true })

-- quickly change background
nmap('<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]])

-- disable highlight until next search
nmap('<esc>', '<cmd>nohlsearch<cr><esc>')
imap('<esc>', '<cmd>nohlsearch<cr><esc>')

-- more convenient way of entering normal mode from terminal mode
tmap([[<c-\><c-\>]], [[<c-\><c-n>]])

-- recall older/recent command-line from history
cmap('<c-j>', '<down>')
cmap('<c-k>', '<up>')

