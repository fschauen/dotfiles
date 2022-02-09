local nmap = require'fs.util'.nmap

local config = function()
  vim.g['rainbow#pairs'] = { {'(',')'}, {'[',']'}, {'{','}'} }

  -- toggle rainbow parens
  nmap { '<leader>p', '<cmd>RainbowParentheses!!<cr>' }
end

return { config = config }

