local nmap = require'fs.util'.nmap

local config = function()
  -- fix whitespace
  nmap { '<leader>w', '<cmd>FixWhitespace<cr>' }
end

return { config = config }

