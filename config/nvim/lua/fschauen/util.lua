local M = {}

-- Flip function arguments.
--
--    flip(f)(a, b) == f(b, a)
--
M.flip = function(f)
  return function(a, b)
    return f(b, a)
  end
end

-- Extend lists.
--
--    extend({'a', 'b'}, {'c', 'd'}) == {'a', 'b', 'c', 'd'}
--    extend({1, 2}, {3, 4}, {5, 6}) == {1, 2, 3, 4, 5, 6}
--
M.extend = function(...)
  local result = {}
  for _, tbl in ipairs {...} do
    for _, v in pairs(tbl) do
      result[#result+1] = v
    end
  end
  return result
end

-- Partial function application:
--
--    partial(f, x)(...)    == f(x, ...)
--    partial(f, x, y)(...) == f(x, y, ...)
--
M.partial = function(f, ...)
  local argv = {...}
  return function(...)
    return f(unpack(M.extend(argv, {...})))
  end
end

--- Delayed function execution.
---@param f function: function whose evaluation will be delayed.
---@param ... any: arguments to `f`.
---@return function: a new function that calls f with provided arguments.
M.thunk = function(f, ...)
  local args = {...}
  return function()
    return f(unpack(args))
  end
end

-- Perform `func` (which can freely use register `reg`) and make sure `reg`
-- is restored afterwards.
M.with_saved_register = function(reg, func)
  local saved = vim.fn.getreg(reg)
  local result = func()
  vim.fn.setreg(reg, saved)
  return result
end

-- Get selected text, or word under cursor if not in visual mode.
M.get_selected_text = function()
  if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

  return M.with_saved_register('v', function()
    vim.cmd [[noautocmd sil norm "vy]]
    return vim.fn.getreg 'v'
  end)
end

local diag_opts = {
  wrap = false, -- don't wrap around the begin/end of file
  float = {
    border = 'rounded' -- enable border for the floating window
  },
}

-- Move to the next diagnostic.
M.goto_next_diagnostic = function(opts)
  vim.diagnostic.goto_next(vim.tbl_extend('keep', opts or {}, diag_opts))
end

-- Move to the previous diagnostic.
M.goto_prev_diagnostic = function(opts)
  vim.diagnostic.goto_prev(vim.tbl_extend('keep', opts or {}, diag_opts))
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

return M

