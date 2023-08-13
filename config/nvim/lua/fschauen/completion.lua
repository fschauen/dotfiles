local M = {}

local cmp = function()
  return require 'cmp'
end

M.select_next_or_complete = function(fallback)
  local func = cmp().visible()
    and cmp().mapping.select_next_item { behavior = cmp().SelectBehavior.Select }
    or cmp().mapping.complete()
  func(fallback)
end

M.select_prev_or_complete = function(fallback)
  local func = cmp().visible()
    and cmp().mapping.select_prev_item { behavior = cmp().SelectBehavior.Select }
    or cmp().mapping.complete()
  func(fallback)
end

M.select_next_item = function(fallback)
  cmp().mapping.select_next_item({ behavior = cmp().SelectBehavior.Select })(fallback)
end

M.select_prev_item = function(fallback)
  cmp().mapping.select_prev_item({ behavior = cmp().SelectBehavior.Select })(fallback)
end

M.scroll_docs = function(delta)
  return function(fallback)
    cmp().mapping.scroll_docs(delta)(fallback)
  end
end

M.abort = function(fallback)
  cmp().mapping.abort()(fallback)
end

M.confirm = function(fallback)
  cmp().mapping.confirm({ select = true })(fallback)
end

return M

