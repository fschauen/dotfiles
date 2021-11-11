vim.cmd([[
    call plug#begin('~/.local/share/nvim/plugged')
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
            let g:rainbow#pairs = [ ['(',')'], ['[',']'], ['{','}'] ]
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
            \       'left': [ ['mode','paste'],[],['ro','modified','path'] ],
            \       'right': [ ['percent'],['lineinfo'],['ft','fenc','ff'] ],
            \   },
            \   'inactive': {
            \       'left': [ ['paste'],['ro','modified','path'] ],
            \       'right': [ ['percent'],['lineinfo'] ],
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
    highlight NonText cterm=NONE ctermfg=10     " subtle EOL symbols
    highlight Whitespace cterm=NONE ctermfg=9   " orange listchars
]])
