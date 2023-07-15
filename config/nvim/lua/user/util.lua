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

-- Partial function application:
--
--    partial(f, x)(...) == f(x, ...)
--
M.partial = function(f, x)
  return function(...)
    return f(x, ...)
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

return M

