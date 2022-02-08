local nmap = require'fs.keymap'.nmap

local config = function()
  -- fix whitespace
  nmap { '<leader>w', '<cmd>FixWhitespace<cr>' }
end

return { config = config }

