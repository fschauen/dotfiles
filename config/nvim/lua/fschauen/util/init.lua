local M = {}

---Check whether file/directory exists.
---@param path string: file or directory path.
---@return string|boolean: type if path exists, false otherwise.
M.exists = function(path)
  local stat = vim.loop.fs_stat(path)
  return (stat and stat.type) or false
end

---Preserve register contents over function call.
---@param reg string: register to save, must be a valid register name.
---@param func function: function that may freely clobber the register.
---@return any: return value of calling `func`.
M.preserve_register = function(reg, func)
  local saved = vim.fn.getreg(reg)
  local result = func()
  vim.fn.setreg(reg, saved)
  return result
end

---Get selected text.
---@return string: selected text, or work under cursor if not in visual mode.
M.get_selected_text = function()
  if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

  return M.preserve_register('v', function()
    vim.cmd [[noautocmd sil norm "vy]]
    return vim.fn.getreg 'v'
  end)
end

return M

