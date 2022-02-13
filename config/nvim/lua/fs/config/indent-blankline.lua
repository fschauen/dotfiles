local nmap = require'fs.util'.nmap

local config = function()
  vim.g.indent_blankline_enabled = false

  require'indent_blankline'.setup()

  vim.cmd [[highlight IndentBlanklineChar ctermfg=10]]

  nmap { '<leader>si', '<cmd>:IndentBlanklineToggle<cr>' }
end

return { config = config }

