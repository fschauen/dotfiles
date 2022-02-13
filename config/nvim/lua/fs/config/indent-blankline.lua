local util = require'fs.util'
local nmap = util.nmap
local colors = util.colors()
local highlight = util.highlight

local config = function()
  vim.g.indent_blankline_enabled = false

  require'indent_blankline'.setup()

  highlight('IndentBlanklineChar') { fg = colors.base01 }

  nmap { '<leader>si', '<cmd>:IndentBlanklineToggle<cr>' }
end

return { config = config }

