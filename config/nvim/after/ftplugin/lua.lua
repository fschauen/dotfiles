vim.bo.tabstop = 2

local lua = require('fschauen.util').lua

local opts = function(desc)
  return { desc = desc, buffer = true }
end

vim.keymap.set('n', 'gf', lua.go_to_module, opts('Go to module under cursor'))
vim.keymap.set('n', '<localleader>x', lua.execute_lines, opts('Execute current line'))
vim.keymap.set('x', '<localleader>x', lua.execute_selection, opts('Execute selection'))
vim.keymap.set('n', '<localleader><localleader>x', lua.execute_file, opts('Execute current file'))

