vim.bo.tabstop = 2

local buffer = { buffer = true }

local exec_current_lua_line = function()
  vim.fn.luaeval(vim.fn.getline('.'))
end

local exec_current_lua_selection = function()
  local selection = { vim.fn.line('v'), vim.fn.line('.') }
  local first, last = vim.fn.min(selection), vim.fn.max(selection)
  local code = vim.fn.join(vim.fn.getline(first, last), '\n')
  loadstring(code)()
end

vim.keymap.set('n', '<leader>x', exec_current_lua_line, buffer)
vim.keymap.set('x', '<leader>x', exec_current_lua_selection, buffer)
vim.keymap.set('n', '<leader><leader>x', '<cmd>write | luafile %<cr>', buffer)

