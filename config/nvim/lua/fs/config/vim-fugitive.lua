local nmap = require'fs.util.keymap'.nmap

local config = function()
  nmap { '<leader>gg',        '<cmd>G<cr>' }
  nmap { '<leader>g<space>',  '<cmd>G ' }
end

return { config = config }

