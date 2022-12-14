local map = vim.keymap.set

-- better navigation for wrapped lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- retain selection when indenting/unindenting in visual mode
map('v', '>', '><cr>gv')
map('v', '<', '<<cr>gv')

-- more intuitive increment/decrement
map('n', '+', '<c-a>')
map('n', '-', '<c-x>')
map('v', '+', 'g<c-a>')
map('v', '-', 'g<c-x>')

-- select all
map('n', '<c-a>', 'gg<s-v>G')

-- easier window navigation
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-h>', '<c-w>h')
map('n', '<c-l>', '<c-w>l')

-- window resizing
map('n', '<s-Up>', '<cmd>resize +1<cr>')
map('n', '<s-Down>', '<cmd>resize -1<cr>')
map('n', '<s-Left>', '<cmd>vertical resize -1<cr>')
map('n', '<s-Right>', '<cmd>vertical resize +1<cr>')

-- easy tab navigation
map('n', '<leader>.', '<cmd>tabnext<cr>', { silent = true })
map('n', '<leader>,', '<cmd>tabprevious<cr>', { silent = true })

-- move lines up and down
map('n', '<c-a-j>', [[:move .+1<cr>==]], { silent = true })
map('n', '<c-a-k>', [[:move .-2<cr>==]], { silent = true })
map('v', '<c-a-j>', [[:move '>+1<cr>gv=gv]], { silent = true })
map('v', '<c-a-k>', [[:move '<-2<cr>gv=gv]], { silent = true })
map('i', '<c-a-j>', [[<esc>:move .+1<cr>==gi]], { silent = true })
map('i', '<c-a-k>', [[<esc>:move .-2<cr>==gi]], { silent = true })

-- move to begin/end of line in insert mode
map('i', '<c-a>', '<c-o>^')
map('i', '<c-e>', '<c-o>$')

-- navigate items in quickfix list
map('n', '<leader>j', '<cmd>cnext<cr>',{ silent = true })
map('n', '<leader>k', '<cmd>cprevious<cr>', { silent = true })

-- cycle through line numbering modes
map('n', '<leader>ln', '<cmd>set nonumber norelativenumber<CR>', { silent = true })
map('n', '<leader>ll', '<cmd>set number norelativenumber<CR>', { silent = true })
map('n', '<leader>lr', '<cmd>set number relativenumber<CR>', { silent = true })

-- show/hide listchars
map('n', '<leader>sl', '<cmd>set list!<CR>', { silent = true })

-- quickly change background
map('n', '<leader>bg', [[<cmd>let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]])

-- disable highlight until next search
map('n', '<leader>h', '<cmd>nohlsearch<cr>')

-- more convenient way of entering normal mode from terminal mode
map('t', [[<c-\><c-\>]], [[<c-\><c-n>]])

-- edit configuration files
map('n', '<leader>eg', '<cmd>tabedit ~/.config/git/config<cr>')
map('n', '<leader>et', '<cmd>tabedit ~/.config/tmux/tmux.conf<cr>')
map('n', '<leader>ev', '<cmd>tabedit ~/.config/nvim/init.lua<cr>')
map('n', '<leader>es', '<cmd>tabedit ~/.config/nvim/spell/en.utf-8.add<cr>')
map('n', '<leader>ez', '<cmd>tabedit ~/.config/zsh/.zshrc<cr>')

