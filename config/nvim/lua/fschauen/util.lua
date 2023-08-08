local M = {}

--- Flip function arguments.
---
---   flip(f)(a, b) == f(b, a)
---
---@param f function: function to flip.
---@return function: function that takes `f`'s arguments flipped.
M.flip = function(f)
  return function(a, b)
    return f(b, a)
  end
end

--- Concatenate lists.
---
---   extend({'a', 'b'}, {'c', 'd'}) == {'a', 'b', 'c', 'd'}
---   extend({1, 2}, {3, 4}, {5, 6}) == {1, 2, 3, 4, 5, 6}
---
---@param ... table: lists to concatenate.
---@return table: concatenation of arguments.
M.concat = function(...)
  local result = {}
  for _, tbl in ipairs {...} do
    for _, v in pairs(tbl) do
      result[#result+1] = v
    end
  end
  return result
end

--- Partial function application.
---
---   partial(f, x)(...)    == f(x, ...)
---   partial(f, x, y)(...) == f(x, y, ...)
---
---@param f function: function to partially apply.
---@param ... any: arguments to bind.
---@return function: partially applied function.
M.partial = function(f, ...)
  local argv = {...}
  return function(...)
    return f(unpack(M.concat(argv, {...})))
  end
end

--- Delayed function evaluation.
---@param f function: function whose evaluation will be delayed.
---@param ... any: arguments to `f`.
---@return function: a new function that calls f with provided arguments.
M.thunk = function(f, ...)
  local args = {...}
  return function()
    return f(unpack(args))
  end
end

--- Preserve register contents over function call.
---@param reg string: register to save, must be a valid register name.
---@param func function: function that may freely clobber the register.
---@return any: return value of calling `func`.
M.with_saved_register = function(reg, func)
  local saved = vim.fn.getreg(reg)
  local result = func()
  vim.fn.setreg(reg, saved)
  return result
end

--- Get selected text.
---@return string: selected text, or work under cursor if not in visual mode.
M.get_selected_text = function()
  if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

  return M.with_saved_register('v', function()
    vim.cmd [[noautocmd sil norm "vy]]
    return vim.fn.getreg 'v'
  end)
end

local diag_opts = {
  wrap = false, -- don't wrap around the begin/end of file
  -- float = {
  --   border = 'rounded' -- enable border for the floating window
  -- },
}

--- Move to the next diagnostic.
---@param opts table: options passed along to `vim.diagnostic.goto_next`.
M.goto_next_diagnostic = function(opts)
  vim.diagnostic.goto_next(vim.tbl_extend('keep', opts or {}, diag_opts))
  vim.cmd 'normal zz'
end

--- Move to the previous diagnostic.
---@param opts table: options passed along to `vim.diagnostic.goto_prev`.
M.goto_prev_diagnostic = function(opts)
  vim.diagnostic.goto_prev(vim.tbl_extend('keep', opts or {}, diag_opts))
  vim.cmd 'normal zz'
end

M.open_float_diagnostic = function(opts)
  vim.diagnostic.open_float(opts)
end

M.toggle_diagnostics = function(bufnr)
  bufnr = bufnr or 0
  if vim.diagnostic.is_disabled(bufnr) then
    vim.diagnostic.enable(bufnr)
  else
    vim.diagnostic.disable(bufnr)
  end
end

M.hide_diagnostics = function(bufnr)
  vim.diagnostic.hide(nil, bufnr or 0)
end

--- Whether the current window is the last in a given direction.
---@param direction string: one of 'h', 'j', 'k', or 'l'
local win_is_last = function(direction)
  local current = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction)
  local next = vim.api.nvim_get_current_win()

  local is_last = current == next
  if not is_last then vim.cmd('wincmd p') end

  return is_last
end

--- Resize current window in a given direction.
---@param dir string: one of 'h', 'j', 'k', or 'l'
---@param size integer: how much to resize
local win_resize = function(dir, size)
  if dir ~= 'h' and dir ~= 'j' and dir ~= 'k' and dir ~= 'l' then return end

  size = math.abs(size)
  local is_height = dir == 'j' or dir == 'k'
  local is_positive = dir == 'j' or dir == 'l'

  if win_is_last(is_height and 'j' or 'l') then
    is_positive = not is_positive
  end

  local delta = string.format('%s%d', is_positive and '+' or '-', size)
  local prefix = is_height and '' or 'vertical '
  vim.cmd(prefix .. 'resize ' .. delta .. '<cr>')
end

--- Resize current window upwards.
---@param size integer: how much to resize
M.win_resize_up    = function(size) return M.thunk(win_resize, 'k', size) end

--- Resize current window downwards.
---@param size integer: how much to resize
M.win_resize_down  = function(size) return M.thunk(win_resize, 'j', size) end

--- Resize current window leftwards.
---@param size integer: how much to resize
M.win_resize_left  = function(size) return M.thunk(win_resize, 'h', size) end

--- Resize current window rightwards.
---@param size integer: how much to resize
M.win_resize_right = function(size) return M.thunk(win_resize, 'l', size) end

--- Toggle quickfix (or location) list.
---@param qf string: 'c' for quickfix, 'l' for location list
local toggle_qf_list = function(qf)
  local l = qf == 'l' and 1 or 0
  local is_qf = function(win) return win.quickfix == 1 and win.loclist == l end
  local is_open = not vim.tbl_isempty(vim.tbl_filter(is_qf, vim.fn.getwininfo()))
  if is_open then
    vim.cmd(qf .. 'close')
  else
    local ok = pcall(function(c) vim.cmd(c) end, qf .. 'open')
    if not ok and qf == 'l' then
      vim.notify('No location list', vim.log.levels.WARN)
    end
  end
end

--- Toggle quickfix list.
M.toggle_quickfix = function() toggle_qf_list('c') end

--- Toggle location list.
M.toggle_loclist = function() toggle_qf_list('l') end

return M

