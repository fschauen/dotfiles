vim.g.mapleader = ' '

-- better navigation for wrapped lines
vim.cmd([[noremap j gj]])
vim.cmd([[noremap k gk]])

-- retain selection when indenting/unindenting in visual mode
vim.cmd([[vnoremap > ><cr>gv]])
vim.cmd([[vnoremap < <<cr>gv]])

-- easier window navigation
vim.cmd([[nnoremap <c-j> <c-w>j]])
vim.cmd([[nnoremap <c-k> <c-w>k]])
vim.cmd([[nnoremap <c-h> <c-w>h]])
vim.cmd([[nnoremap <c-l> <c-w>l]])

-- window resizing
vim.cmd([[nnoremap <Up>     <cmd>resize +1<cr>]])
vim.cmd([[nnoremap <Down>   <cmd>resize -1<cr>]])
vim.cmd([[nnoremap <Left>   <cmd>vertical resize -1<cr>]])
vim.cmd([[nnoremap <Right>  <cmd>vertical resize +1<cr>]])

-- easier tab navigation
vim.cmd([[nnoremap <silent> <c-n> :tabprevious<cr>]])
vim.cmd([[nnoremap <silent> <c-m> :tabnext<cr>]])

-- move lines up and down
vim.cmd([[nnoremap <silent> <A-j>      :move .+1<cr>==]])
vim.cmd([[nnoremap <silent> <A-k>      :move .-2<cr>==]])
vim.cmd([[vnoremap <silent> <A-j>      :move '>+1<cr>gv=gv]])
vim.cmd([[vnoremap <silent> <A-k>      :move '<-2<cr>gv=gv]])
vim.cmd([[inoremap <silent> <A-j> <esc>:move .+1<cr>==gi]])
vim.cmd([[inoremap <silent> <A-k> <esc>:move .-2<cr>==gi]])

-- cycle through line numbering modes
vim.cmd([[nnoremap <silent> <leader>ln :set nonumber norelativenumber<CR>]])
vim.cmd([[nnoremap <silent> <leader>ll :set number norelativenumber<CR>]])
vim.cmd([[nnoremap <silent> <leader>lr :set number relativenumber<CR>]])

-- show list of buffers and prepare to switch
vim.cmd([[nnoremap <leader>bf :ls<CR>:b<Space>]])

-- quickly change background
vim.cmd([[nnoremap <leader>bg :let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]])

-- toggle search highlight
vim.cmd([[nnoremap <leader>h :set hlsearch!<cr>]])

-- toggle NERDTree
vim.cmd([[nnoremap <leader>n :NERDTreeToggle<cr>]])

-- toggle rainbow parens
vim.cmd([[nnoremap <leader>p :RainbowParentheses!!<cr>]])

-- fix whitespace
vim.cmd([[nnoremap <leader>w :FixWhitespace<cr>]])


-- " Double leader key for toggling visual-line mode
-- nmap <Leader><Leader> V
-- xmap <Leader><Leader> <Esc>

-- " Toggle fold
-- nnoremap <CR> za

-- nnoremap Q q
-- nnoremap gQ @q

-- " Start new line from any cursor position in insert-mode
-- inoremap <S-Return> <C-o>o

-- " Change current word in a repeatable manner
-- nnoremap <Leader>cn *``cgn
-- nnoremap <Leader>cN *``cgN

-- " Change the current word in insertmode.
-- "   Auto places you into the spot where you can start typing to change it.
-- nnoremap <c-w><c-r> :%s/<c-r><c-w>//g<left><left>

