vim.cmd([[
  augroup VagrantDetect
    autocmd!
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
  augroup END
]])

