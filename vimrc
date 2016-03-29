set nocompatible

" Options {{{
    set   autoindent
    set   autoread
    let  &background = $BACKGROUND ==# 'light' ? 'light' : 'dark'
    set   backspace=indent,eol,start
    set nobackup
    set   clipboard=unnamed
    set   colorcolumn=80
    set   cursorline
    set   encoding=utf8
    set   expandtab
    set   foldenable
    set   foldlevelstart=100
    set   foldmethod=syntax
    set   foldnestmax=10
    set   formatoptions-=t
    set   hidden
    set   history=1000
    set   hlsearch
    set   incsearch
    set   laststatus=2
    set   lazyredraw
    set   listchars=tab:›\ ,trail:·
    set   modelines=0
    set   number
    set   scrolloff=5
    set   shiftwidth=4
    let  &showbreak = '↪ '
    set   showmatch
    set noshowmode
    set   sidescrolloff=5
    set   nrformats-=octal
    set   smartindent
    set   smarttab
    set   splitbelow
    set   splitright
    set noswapfile
    set   tabstop=4
    set   textwidth=79
    set   timeoutlen=1000
    set   ttimeoutlen=100
    set   ttyfast
    set   wildignore=*.o,*.obj,*.pyc,*.exe,*.so,*.dll
    set   wildmenu
    set   wrap
    set   writebackup
" }}}

" Plugins {{{
    call plug#begin('~/.vim/bundle')
        Plug 'altercation/vim-colors-solarized'
        Plug 'benmills/vimux'
        Plug 'bronson/vim-trailing-whitespace'
        Plug 'davidoc/taskpaper.vim'
        Plug 'elzr/vim-json'
        Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
        Plug 'junegunn/rainbow_parentheses.vim'
        Plug 'junegunn/vim-easy-align'
        Plug 'kien/ctrlp.vim'
        Plug 'majutsushi/tagbar'
        Plug 'scrooloose/nerdtree'
        Plug 'tpope/vim-commentary'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
    call plug#end()

    let g:ctrlp_match_window = 'bottom,order:ttb'
    let g:ctrlp_switch_buffer = 0       " open files in new buffer
    let g:ctrlp_working_path_mode = 0   " use the current working directory

    let g:rainbow#pairs = [['(',')'], ['[',']'], ['{','}']]

    highlight link taskpaperDone          Comment
    highlight link taskpaperCancelled     Comment
    highlight link taskpaperComment       Normal

    let g:airline_theme="solarized"
    let g:airline_powerline_fonts = 1

    colorscheme solarized
    filetype plugin indent on
    syntax enable
" }}}

" Mappings {{{
    let mapleader = "\<space>"
    let maplocalleader = ","

    " Start interactive EasyAlign
    nmap ga <Plug>(EasyAlign)
    xmap ga <Plug>(EasyAlign)

    " better navigation for wrapped lines
    noremap j gj
    noremap k gk

    " quickly exit insert mode
    inoremap jk <esc>

    " retain selection when indenting/unindenting in visual mode
    vnoremap > ><cr>gv
    vnoremap < <<cr>gv

    " case insensitive searching
    nnoremap // /\c
    nnoremap ?? ?\c

    " window resizing similar to the way I have tmux set up
    nnoremap <c-w><c-k> 5<c-w>+
    nnoremap <c-w><c-j> 5<c-w>-
    nnoremap <c-w><c-h> 5<c-w><
    nnoremap <c-w><c-l> 5<c-w>>

    " easier tab navigation
    nnoremap <c-j> :tabprevious<cr>
    nnoremap <c-k> :tabnext<cr>
    nnoremap <c-h> :tabfirst<cr>
    nnoremap <c-l> :tablast<cr>

    " quickly change background
    nnoremap <leader>bg
        \ :let &background = &background ==# 'light' ? 'dark' : 'light'<cr>

    " toggle tagbar
    nnoremap <leader>g :TagbarToggle<cr>

    " turn off search highlight
    nnoremap <leader>h :nohlsearch<cr>

    " toggle NERDTree
    nnoremap <leader>n :NERDTreeToggle<cr>

    " toggle rainbow parens
    nnoremap <leader>r :RainbowParentheses!!<cr>

    " fix whitespace
    nnoremap <leader>w :FixWhitespace<cr>
" }}}"

augroup vimrc " {{{
    autocmd!
    autocmd BufNewFile,BufRead bash_profile,bashrc set filetype=sh
    autocmd BufNewFile,BufRead gitconfig set filetype=gitconfig
    autocmd BufNewFile,BufRead rcrc set filetype=sh

    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType python setlocal foldmethod=indent foldignore=
    autocmd FileType markdown,text,gitcommit setlocal formatoptions+=t spell
    autocmd FileType gitcommit setlocal textwidth=72
augroup END " }}}

if filereadable(expand("~/.vimrc.local")) | source ~/.vimrc.local | endif
