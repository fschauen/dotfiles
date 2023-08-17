local M = { 'mbbill/undotree' }

M.init = function()
  vim.g.undotree_WindowLayout = 2  -- tree: left, diff: bottom
  vim.g.undotree_DiffAutoOpen = 0  -- don't open diff by default
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.g.undotree_TreeNodeShape  = ''
  vim.g.undotree_TreeVertShape  = '│'
  vim.g.undotree_TreeSplitShape = '╱'
  vim.g.undotree_TreeReturnShape = '╲'
end

M.keys = require('fschauen.keymap').undotree

M.config = false

return M

