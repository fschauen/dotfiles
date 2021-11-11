let mapleader = "\<space>"
let maplocalleader = ","

" better navigation for wrapped lines
noremap j gj
noremap k gk

" retain selection when indenting/unindenting in visual mode
vnoremap > ><cr>gv
vnoremap < <<cr>gv

" window resizing similar to the way I have tmux set up
nnoremap <c-w><c-k> 5<c-w>+
nnoremap <c-w><c-j> 5<c-w>-
nnoremap <c-w><c-h> 5<c-w><
nnoremap <c-w><c-l> 5<c-w>>

" easier window navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" easier tab navigation
nnoremap <c-n> :tabprevious<cr>
nnoremap <c-m> :tabnext<cr>

" show list of buffers and prepare to switch
nnoremap <leader>bf :ls<CR>:b<Space>

" quickly change background
nnoremap <leader>bg
    \ :let &background = &background ==? 'light' ? 'dark' : 'light'<cr>

" toggle search highlight
nnoremap <leader>h :set hlsearch!<cr>

" toggle NERDTree
nnoremap <leader>n :NERDTreeToggle<cr>

" toggle rainbow parens
nnoremap <leader>p :RainbowParentheses!!<cr>

" fix whitespace
nnoremap <leader>w :FixWhitespace<cr>

" cycle through line numbering modes
nnoremap <leader>ln :set nonumber norelativenumber<CR>
nnoremap <leader>ll :set number norelativenumber<CR>
nnoremap <leader>lr :set number relativenumber<CR>

" move lines up and down
nnoremap <A-j> :move .+1<cr>
nnoremap <A-k> :move .-2<cr>
vnoremap <A-j> :move '>+1<cr>gv
vnoremap <A-k> :move '<-2<cr>gv

