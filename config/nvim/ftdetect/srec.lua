vim.cmd([[
  augroup SrecDetect
    autocmd!
    autocmd BufNewFile,BufRead *.sx,*.s19 set filetype=srec
  augroup END
]])

