vim.bo.tabstop = 2

local buffer = { buffer = true }

local exec_current_lua_line = function()
  local lineno = vim.fn.line('.')
  print('Executing line ' .. lineno)
  vim.fn.luaeval(vim.fn.getline(lineno))
end

local exec_current_lua_selection = function()
  local selection = { vim.fn.line('v'), vim.fn.line('.') }
  local first, last = vim.fn.min(selection), vim.fn.max(selection)
  local code = vim.fn.join(vim.fn.getline(first, last), '\n')
  print('Executing lines ' .. first .. ' to ' .. last)
  loadstring(code)()
end

local lua_go_to_file = function()
  require('fschauen.util').edit_lua_module(vim.fn.expand('<cfile>'))
end

vim.keymap.set('n', 'gf', lua_go_to_file, buffer)
vim.keymap.set('n', '<localleader>x', exec_current_lua_line, buffer)
vim.keymap.set('x', '<localleader>x', exec_current_lua_selection, buffer)
vim.keymap.set('n', '<localleader><localleader>x', '<cmd>write | luafile %<cr>', buffer)

