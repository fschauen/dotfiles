local util = require('user.util')
local partial = util.partial
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

-- retain selection when making changes in visual mode
vmap( '<c-a>',  '<c-a>gv')
vmap( '<c-x>',  '<c-x>gv')
vmap('g<c-a>', 'g<c-a>gv')
vmap('g<c-x>', 'g<c-x>gv')
vmap('>', '><cr>gv')
vmap('<', '<<cr>gv')

-- place destination of important movements in the center of the screen
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')
nmap('<c-d>', '<c-d>zzzv')
nmap('<c-u>', '<c-u>zzzv')

-- easier window navigation
nmap('<c-j>', '<c-w>j')
nmap('<c-k>', '<c-w>k')
nmap('<c-h>', '<c-w>h')
nmap('<c-l>', '<c-w>l')

-- window resizing
nmap('<s-Up>',       util.win_resize_up(2), { desc = 'Resize window upward' })
nmap('<s-Down>',   util.win_resize_down(2), { desc = 'Resize window downward' })
nmap('<s-Left>',   util.win_resize_left(2), { desc = 'Resize window leftward' })
nmap('<s-Right>', util.win_resize_right(2), { desc = 'Resize window rightward' })

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

-- navigate items in quickfix and location lists
nmap('<Down>',   '<cmd>cnext<cr>zz',     { silent = true })
nmap('<Up>',     '<cmd>cprevious<cr>zz', { silent = true })
nmap('<a-Down>', '<cmd>lnext<cr>zz',     { silent = true })
nmap('<a-Up>',   '<cmd>lprevious<cr>zz', { silent = true })

-- navigate diagnostics
nmap('<leader>j', require('user.util').goto_next_diagnostic)
nmap('<leader>k', require('user.util').goto_prev_diagnostic)

-- quickly open lazy.nvim plugin manager
nmap('<leader>L', '<cmd>Lazy<cr>')

-- toggle options
local toggle_number = function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = false
end

local toggle_relativenumber = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = vim.wo.relativenumber or vim.wo.number
end

nmap('<leader>sn', toggle_number)
nmap('<leader>sr', toggle_relativenumber)
nmap('<leader>sl', '<cmd>set list! | set list?<CR>', { silent = true })
nmap('<leader>sw', '<cmd>set wrap! | set wrap?<CR>', { silent = true })
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

