local M = {}

-- Features to implement:
--  [ ] increase/decrease heading level
--  [ ] change _current_ heading type (setex/atx)
--  [ ] jump to previous/next header
--  [ ] generate TOC
--  [ ] go to file in link (with `gf`)
--  [ ] open URLs with browser
--  [ ] folding?

local preserve_mark = function(buffer, name, fn)
  local line, col = unpack(vim.api.nvim_buf_get_mark(buffer, name))
  local result = fn()
  vim.api.nvim_buf_set_mark(buffer, name, line, col, {})
  return result
end

-- local preserve_cursor = function(fn)
--   local mark = 'a'
--   return preserve_mark(0, mark, function()
--     vim.api.nvim_command('mark ' .. mark)
--     local result = fn()
--     vim.api.nvim_win_set_cursor(0, vim.api.nvim_buf_get_mark(0, mark))
--     return result
--   end)
-- end

local preserve_view = function(fn)
  local mark = 'a'
  return preserve_mark(0, mark, function()
    local view = vim.fn.winsaveview()
    vim.api.nvim_command('mark ' .. mark)

    local result = fn()

    local line, col = unpack(vim.api.nvim_buf_get_mark(0, mark))
    view.topline = line - (view.lnum - view.topline)
    view.lnum = line
    view.col = col
    vim.fn.winrestview(view)

    return result
  end)
end

M.heading_setex = function()
-- TODO: add an option to extend the Setex underline until 'textwidth'
-- TODO: make it possible to use a range instead of the whole file
  preserve_view(function()
    vim.api.nvim_command([[silent! %s/\v^#\s+(.*)$/\=submatch(1)."\r".repeat('=', len(submatch(1)))/]])
    vim.api.nvim_command([[silent! %s/\v^##\s+(.*)$/\=submatch(1)."\r".repeat('-', len(submatch(1)))/]])
  end)
end

M.heading_atx = function()
  preserve_view(function()
    vim.api.nvim_command([[silent! %s/\v(.*\S.*)\n\=+$/# \1]])
    vim.api.nvim_command([[silent! %s/\v(.*\S.*)\n\-+$/## \1]])
  end)
end

M.setup = function()
  vim.keymap.set('n', '<localleader>hs', M.heading_setex, { buffer = 0 })
  vim.keymap.set('n', '<localleader>ha', M.heading_atx, { buffer = 0 })
end

return M

