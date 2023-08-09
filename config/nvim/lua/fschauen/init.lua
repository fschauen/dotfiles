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

M.colorscheme = function(name)
  vim.cmd('silent! colorscheme ' .. name)
  if vim.v.errmsg ~= '' then
    vim.notify(string.format('Colorscheme %s not found!', name), vim.log.levels.WARN)
  end
end

return M

