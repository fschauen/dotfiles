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
augroup END " }}}

