vim.bo.tabstop = 2

local nmap = require 'fs.keymap'.buffer_nmap

-- execute the current line
nmap { '<leader>x', [[<cmd>call luaeval(getline("."))<cr>]] }

-- save and execute the current file
nmap { '<leader><leader>x', '<cmd>silent write | luafile %<cr>' }

