vim.g['rainbow#pairs'] = { {'(',')'}, {'[',']'}, {'{','}'} }

local nmap = require'fs.keymap'.nmap

-- toggle rainbow parens
nmap { '<leader>p', '<cmd>RainbowParentheses!!<cr>' }

