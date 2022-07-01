vim.bo.tabstop = 2

local nmap = require 'fs.util'.nmap
local buffer = { buffer = true }

-- execute the current line
nmap { '<leader>x', [[<cmd>call luaeval(getline("."))<cr>]], buffer }

-- save and execute the current file
nmap { '<leader><leader>x', '<cmd>silent write | luafile %<cr>', buffer }

