P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

vim.g.mapleader = ' '

require 'fs.disable_builtin'
require 'fs.options'
require 'fs.plugins'
require 'fs.keymaps'
require 'fs.autocmds'

