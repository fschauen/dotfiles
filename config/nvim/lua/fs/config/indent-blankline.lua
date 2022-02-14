local nmap = require'fs.util'.nmap

local config = function()
  require'indent_blankline'.setup { enabled = false }

  -- show/hide indent guides
  nmap { '<leader>si', '<cmd>:IndentBlanklineToggle<cr>' }
end

return { config = config }

