local nmap = require'fs.util'.nmap

local config = function()
  vim.g['rainbow#pairs'] = { {'(',')'}, {'[',']'}, {'{','}'} }

  -- show/hide rainbow parens
  nmap { '<leader>sp', '<cmd>RainbowParentheses!!<cr>' }
end

return { config = config }

