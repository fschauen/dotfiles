set nocompatible
let mapleader = ","

" Vim options {{{
    set background=dark             " use dark background
    set backspace=indent,eol,start  " allow backspace over everything
    set clipboard=unnamed           " use system clipboard for yank/put/delete
    set colorcolumn=80              " highlight column 80
    set cursorline                  " highlight current line
    set encoding=utf8               " use UTF-8 by default
    set expandtab                   " expand <Tab> to spaces in Insert mode
    set foldenable                  " enable folding
    set foldlevelstart=100          " open all folds when opening
    set foldmethod=syntax           " fold based on syntax  by default
    set foldnestmax=10              " avoid folds too deeply nested
    set formatoptions-=t            " don't auto wrap when typing
    set hidden                      " allow switch away from buffer w/o writing
    set history=1000                " remember 1000 commnand lines
    set hlsearch                    " highlight matches for last search pattern
    set incsearch                   " show match for partly typed search command
    set laststatus=2                " always show the status line
    set lazyredraw                  " don't redraw when executing macros
    set listchars=tab:▸\ ,trail:·,eol:¶
    set nobackup                    " don't keep a backup after overwriting a file
    set noshowmode                  " hide mode since it's shown in airline
    set noswapfile                  " don't use swap files
    set number                      " show line numbers
    set scrolloff=7                 " number of screen lines to show around the cursor
    set shiftwidth=4                " number of spaces used for each step of (auto)indent
    set showmatch                   " show matching brackets
    set smartindent                 " do clever autoindenting
    set smarttab                    " a <Tab> in an indent inserts 'shiftwidth' spaces
    set splitbelow                  " new horizontal splits go below current
    set splitright                  " new vertical splits to the right of current
    set tabstop=4                   " number of spaces a <Tab> in the text stands for
    set textwidth=79                " break lines at 79 characters
    set timeoutlen=1000             " timeout of 1s for key combinations
    set ttimeoutlen=100             " timeout of 100ms for <esc>
    set ttyfast                     " fast terminal connection
    set wildignore=*.o,*.obj,*.pyc,*.exe,*.so,*.dll
    set wildmenu                    " enhanced command-line completion
    set wrap                        " wrap long lines
    set writebackup                 " make a backup before writing a file
    if has('multi_byte')
        let &showbreak='↳'
    else
        let &showbreak=' '
    endif
" }}}

" Plugins {{{
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'gmarik/Vundle.vim'

    Plugin 'altercation/vim-colors-solarized'
    Plugin 'benmills/vimux'
    Plugin 'bling/vim-airline'
    Plugin 'bronson/vim-trailing-whitespace'
    Plugin 'kien/ctrlp.vim'
    Plugin 'majutsushi/tagbar'
    Plugin 'scrooloose/nerdtree'
    Plugin 'davidoc/taskpaper.vim'
    Plugin 'scrooloose/syntastic'
    Plugin 'tpope/vim-fugitive'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'junegunn/vim-easy-align'
    Plugin 'junegunn/rainbow_parentheses.vim'

    call vundle#end()
    filetype plugin indent on
    syntax enable

    " ctrlp {{{
        let g:ctrlp_match_window = 'bottom,order:ttb'
        let g:ctrlp_switch_buffer = 0       " open files in new buffer
        let g:ctrlp_working_path_mode = 0   " use the current working directory
    " }}}

    " nerdtree {{{
        nmap <leader>n :NERDTreeToggle<cr>
    " }}}

    " rainbow_parentheses {{{
        let g:rainbow#pairs = [['(',')'], ['[',']'], ['{','}']]
        nnoremap <leader>r :RainbowParentheses!!<cr> " toggle rainbow parens
    " }}}

    " tagbar {{{
        nnoremap <leader>g :TagbarToggle<cr>
    " }}}

    " taskpaper {{{
        " relink some of the default highlight groups for visual improvement
        hi link taskpaperDone          Comment
        hi link taskpaperCancelled     Comment
        hi link taskpaperComment       Normal
    " }}}

    " vim-airline {{{
        let g:airline_theme="solarized"
        let g:airline_powerline_fonts = 1
    " }}}

    " vim-colors-solarized {{{
        silent! colorscheme solarized
    " }}}

    " vim-trailing-whitespace {{{
        nnoremap <leader>w :FixWhitespace<cr>
    " }}}

    " vim-easy-align {{{
        xmap ga <Plug>(EasyAlign)
        xmap ga <Plug>(EasyAlign)
    " }}}
" }}}

augroup vimrc " {{{
    autocmd!
    au BufNewFile,BufRead *.md set ft=markdown
    au BufNewFile,BufRead bash_profile,bashrc set ft=sh
    au BufNewFile,BufRead gitconfig set ft=gitconfig
    au BufNewFile,BufRead rcrc set ft=sh

    au FileType vim setl foldmethod=marker
    au FileType python setl foldmethod=indent
    au FileType markdown,text setl formatoptions+=t | setl spell
    au FileType gitcommit setl formatoptions+=t | setl spell | setl textwidth=72
augroup END " }}}

" Key mappings {{{
    " window resizing similar to the way I have tmux set up
    nnoremap <c-w><c-k> 5<c-w>+
    nnoremap <c-w><c-j> 5<c-w>-
    nnoremap <c-w><c-h> 5<c-w><
    nnoremap <c-w><c-l> 5<c-w>>

    " retain selection when indenting/unindenting in visual mode
    vnoremap > ><cr>gv
    vnoremap < <<cr>gv

    " case insensitive searching
    nnoremap // /\c
    nnoremap ?? ?\c

    " quickly exit insert mode
    inoremap jk <esc>

    " better navigation for wrapped lines
    noremap j gj
    noremap k gk

    " space opens/closes folds
    nnoremap <space> za

    " turn off search highlight
    nnoremap <leader><leader> :nohlsearch<cr>

    " switch between last two files
    nnoremap <leader><space> <c-^>

    " quickly change background
    nnoremap <leader>bd :set background=dark<cr>
    nnoremap <leader>bl :set background=light<cr>
" }}}

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
