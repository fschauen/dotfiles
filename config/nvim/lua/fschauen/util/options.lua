local M = {}

M.toggle_number = function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = false
end

M.toggle_relativenumber = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = vim.wo.relativenumber or vim.wo.number
end

M.toggle_list = function()
  vim.wo.list = not vim.wo.list
  vim.cmd([[set list?]])
end

M.toggle_wrap = function()
  vim.wo.wrap = not vim.wo.wrap
  vim.cmd([[set wrap?]])
end

M.toggle_spell = function()
  vim.wo.spell = not vim.wo.spell
  vim.cmd([[set spell?]])
end

M.set_gitcommit_buffer_options = function()
  print('here we are!')
  vim.bo.textwidth = 72
  vim.opt.formatoptions:append('t') -- wrap text on 'textwidth'
  vim.opt.spell = true              -- turn on spell checking
end

return M
