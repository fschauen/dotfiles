local M = {}

P = function(v)
  print(vim.inspect(v))
  return v
end

R = function(module)
  require('plenary.reload').reload_module(module)
  return require(module)
end

M.setup = function()
  require('fschauen.options').setup()
  require('fschauen.keymap').setup()
  require('fschauen.diagnostic').setup()
  require('fschauen.autocmd').setup()
  require('fschauen.filetype').setup()
  require('fschauen.lazy').setup()
  require('fschauen.colorscheme').setup()
end

return M

