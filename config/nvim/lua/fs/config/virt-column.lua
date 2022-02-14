local nmap = require'fs.util'.nmap

local toggle = function()
  if vim.o.colorcolumn == '' then
    vim.o.colorcolumn = '+1'
  else
    vim.o.colorcolumn = ''
  end
end

local config = function()
  require'virt-column'.setup { char = '│' }

  -- show/hide virtual colorcolumn
  nmap { '<leader>sc', [[<cmd>lua require'fs.config.virt-column'.toggle()<cr>]] }
end

return { config = config, toggle = toggle }

