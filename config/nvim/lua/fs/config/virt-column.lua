local util = require'fs.util'
local nmap = util.nmap
local colors = util.colors()
local highlight = util.highlight

local toggle = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'
  else
    vim.o.colorcolumn = ''
  end
end

local config = function()
  require'virt-column'.setup { char = '│' }

  highlight('VirtColumn') { fg = colors.base02, attrs = 'NONE' }

  nmap { '<leader>sc', '<cmd>lua require"fs.config.virt-column".toggle()<cr>' }
end

return { config = config, toggle = toggle }

