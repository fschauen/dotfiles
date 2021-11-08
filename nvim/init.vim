if $XDG_CONFIG_HOME == "" | let $XDG_CONFIG_HOME="~/.config" | endif
if $XDG_CACHE_HOME == "" | let $XDG_CACHE_HOME="~/.cache" | endif
if $XDG_DATA_HOME == "" | let $XDG_DATA_HOME="~/.local/share" | endif

" Options {{{
set   backspace=indent,eol,start  " sane backspace behavior
set   background=dark   " always use dark background
set   belloff=all       " never ring bells
set nobackup            " don't keep backup file after overwriting a file
set   clipboard=unnamedplus " synchronize with system clipboard
set   colorcolumn=+1    " highlight column after 'textwidth'
set   cursorline        " highlight the line of the cursor
set   diffopt=filler,vertical   " make side-by-side diffs better
set noequalalways       " don't resize all windows when splitting
set   expandtab         " use spaces whe <Tab> is inserted
set   fileformats=unix,mac,dos  " prioritize unix <EOL> format
set   foldenable        " enable folding
set   foldlevelstart=100  " start with all folds open
set   foldmethod=syntax  " fold based on syntax by default
set   foldnestmax=10  " limit nested folds to 10 levels
set   formatlistpat="^\s*\(\d\+[\]:.)}\t ]\|[-*]\|\[[ x]\]\|([ x])\)\s*"
set   formatoptions-=t  " don't auto-wrap on 'textwidth'...
set   formatoptions+=c  " ... but do it within comnment blocks.
set   formatoptions+=r  " insert comment leader when pressing Enter...
set   formatoptions-=o  " but not when openine a new line with o & O.
set   formatoptions+=q  " allow formatting of comments with gq
set   formatoptions-=a  " don't auto-format every time text is inserted
set   formatoptions+=n  " recognize and indent lists automatically
set   formatoptions+=j  " remove comment leader when joining lines
set   hidden            " hide abandoned buffers
set   ignorecase        " ignore case when searching (see 'smartcase' below)
let  &inccommand='split' " show command partial results
set nojoinspaces        " use one space after a period whe joining lines
set   lazyredraw        " don't redraw screen when executing macros
set   list              " show invisible characters
set   listchars=tab:>~,extends:>,precedes:<,trail:-  " invisible chars
set   modelines=0       " never use modelines
set   number            " show line numbers
set   nrformats-=octal  " number formats for CTRL-A & CTRL-X commands
set   relativenumber    " start off with realtive line numbers
set   scrolloff=3       " minimum number of lines above and below cursor
set   shiftwidth=0      " use 'tabstop' spaces for (auto)indent step
set   shortmess+=I      " don't show the intro message when starting Vim
set   showbreak="-> "   " prefix for wrapped lines
set   showmatch         " briefly jump to matching bracket if insert one
set noshowmode          " don't show mode (shown in statusline instead)
set   sidescrolloff=3   " min. number of columns to left and right of cursor
set   smartcase         " case sensitive search if pattern has uppercase chars
set   smartindent       " use smart autoindenting
set   splitbelow        " new window from split is below the current one
set   splitright        " new window is put right of the current one
set noswapfile          " don't use swap files
set   tabstop=4         " tabs are 4 spaces
set   textwidth=79      " maximum width for text being inserted
set   virtualedit=block  " position the cursor anywhere in Visual Block mode
set   wildignore=*.o,*.obj,*.pyc,*.exe,*.so,*.dll
set   wildignorecase    " ignore case when completing file names
set   wildmode=longest,list,full  " complete longest common, then list, then wildmenu
set   wrap              " wrap long lines
set   writebackup       " make a backup before overwriting a file

      "   +--Disable hlsearch while loading viminfo
      "   | +--Remember marks for last 100 files
      "   | |    +--Remember up to 1000 lines in each register
      "   | |    |      +--Remember up to 1MB in each register
      "   | |    |      |     +--Remember last 1000 search patterns
      "   | |    |      |     |     +---Remember last 1000 commands
      "   | |    |      |     |     |    +-- name of shared data file
      "   | |    |      |     |     |    |
      "   v v    v      v     v     v    v
set shada=h,'100,<1000,s1000,/1000,:1000,n$XDG_DATA_HOME/nvim/shada/main.shada

" Overrides when UTF-8 is available
if has('multi_byte') && &encoding ==? 'utf-8'
set   fillchars=vert:┃,fold:·
set   showbreak=⤷   " prefix for wrapped lines
set   listchars=tab:▷\ ,extends:»,precedes:«,trail:·  " invisible chars
endif
" }}}

" Plugins {{{
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
    Plug 'altercation/vim-colors-solarized'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'elzr/vim-json'
        " Disable quote concealling.
        let g:vim_json_syntax_conceal = 0
        " Make numbers and booleans stand out.
        highlight link jsonBraces   Text
        highlight link jsonNumber   Identifier
        highlight link jsonBoolean  Identifier
        highlight link jsonNull     Identifier
    Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
        let g:vim_markdown_conceal_code_blocks = 0
    Plug 'junegunn/rainbow_parentheses.vim'
        let g:rainbow#pairs = [['(',')'], ['[',']'], ['{','}']]
    Plug 'ctrlpvim/ctrlp.vim'
        let g:ctrlp_match_window = 'bottom,order:ttb'
        let g:ctrlp_switch_buffer = 0       " open files in new buffer
        let g:ctrlp_show_hidden = 1         " show hidden files
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'tpope/vim-commentary'
    Plug 'itchyny/lightline.vim'
        let g:lightline = {
        \   'colorscheme': 'solarized',
        \   'active': {
        \       'left': [['mode','paste'],[],['ro','modified','path']],
        \       'right': [['percent'],['lineinfo'],['ft','fenc','ff']],
        \   },
        \   'inactive': {
        \       'left': [['paste'],['ro','modified','path']],
        \       'right': [['percent'],['lineinfo']],
        \   },
        \   'component': {
        \       'fenc':     '%{&fenc!=#""?&fenc:&enc}',
        \       'ff':       '%{&ff}',
        \       'ft':       '%{&ft!=#""?&ft:"?"}',
        \       'modified': '%M',
        \       'paste':    '%{&paste?"PASTE":""}',
        \       'path':     '%f',
        \       'percent':  '%3p%%×%L',
        \       'ro':       '%R',
        \   },
        \   'subseparator': { 'left': '', 'right': '' },
        \ }
    Plug 'vim-scripts/srec.vim'
        highlight link srecStart        Comment
        highlight link srecType         Comment
        highlight link srecLength       WarningMsg
        highlight link srec16BitAddress Constant
        highlight link srec24BitAddress Constant
        highlight link srec32BitAddress Constant
        highlight link srecChecksum     Type
    Plug 'keith/swift.vim'
    Plug 'chr4/nginx.vim'
call plug#end()

silent! colorscheme solarized
" }}}

" Mappings {{{
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
" }}}"

augroup vimrc " {{{
    autocmd!

    autocmd BufNewFile,BufRead bash_profile,bashrc,profile set filetype=sh
    autocmd BufNewFile,BufRead gitconfig set filetype=gitconfig
    autocmd BufNewFile,BufRead *.sx,*.s19 set filetype=srec
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
    autocmd BufNewFile,BufRead init.vim set foldmethod=marker

    autocmd FileType python setlocal foldmethod=indent foldignore=
    autocmd FileType markdown,text,gitcommit setlocal formatoptions+=t spell
    autocmd FileType gitcommit setlocal textwidth=72

    " Disable cursorline in INSERT mode.
    autocmd InsertEnter,InsertLeave * set cursorline!

    autocmd BufWritePost init.vim source %
augroup END " }}}

