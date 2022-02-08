local config = function()
  vim.cmd [[
    silent! colorscheme solarized
    highlight Normal ctermbg=NONE               " transparent background
    highlight NonText cterm=NONE ctermfg=10     " subtle EOL symbols
    highlight Whitespace cterm=NONE ctermfg=9   " orange listchars
  ]]
end

return { config = config }

