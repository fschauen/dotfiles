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
let  &formatlistpat='^\s*\(\d\+[\]:.)}\t ]\|[-+*]\|[\[(][ x][\])]\)\s*'
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
set   listchars=tab:»\ ,extends:…,precedes:…,trail:·,conceal:┊,eol:↲
endif

