local M = {}

M.filename = require('lualine.component'):extend()

function M.filename:init(options)
  M.filename.super.init(self, options)

  local color = options.color or {}
  local modified = { gui = 'italic' }

  self.custom_highlights = {   -- [is_focused, modified]
    [true] = {
      [true]  = self:create_hl(vim.tbl_extend('force', color, modified), 'focus_modified'),
      [false] = self:create_hl(color, 'focus'),
    },
    [false] = {
      [true]  = self:create_hl(modified, 'nofocus_modified'),
      [false] = self:create_hl({}, 'nofocus'),
    },
  }
end

function M.filename:update_status(is_focused)
  self.options.color_highlight = self.custom_highlights[is_focused][vim.bo.modified]

  local window = require 'fschauen.window'
  local path = vim.fn.expand('%:~:.')

  if window.is_wide() then
    return path
  elseif window.is_medium() then
    return vim.fn.pathshorten(path)         -- only first letter of directories
  else
    return vim.fn.fnamemodify(path, ':t')   -- only tail
  end
end


M.mode = require('lualine.component'):extend()

M.mode.map = {
  ['n']  = '', -- 'Normal ', -- Normal
  ['no'] = '', -- 'O-Pend ', -- Operator-pending
  ['ni'] = '', -- 'Normal ', -- Normal via i_CTRL-O
  ['v']  = '󰒉', -- 'Visual ', -- Visual by character
  [''] = '󰩭', -- 'V-Block', -- Visual blockwise
  ['s']  = '󰒉', -- 'Select ', -- Select by character
  [''] = '󰩭', -- 'S-Block', -- Select blockwise
  ['i']  = '', -- 'Insert ', -- Insert
  ['r']  = '󰄾', -- 'Replace', -- Replace
  ['rv'] = '󰶻', -- 'V-Repl ', -- Virtual Replace
  ['c']  = '', -- 'Command', -- Command-line
  ['cv'] = '', -- '  Ex   ', -- Ex mode
  ['rm'] = '', -- ' modeore  ', -- -- modeORE --
  ['r?'] = '󰭚', -- 'Confirm', -- :confirm
  ['!']  = '', -- ' Shell ', -- External command executing
  ['t']  = '', -- ' Term  ', -- Terminal
}

function M.mode:update_status(is_focused)
  if is_focused then
    local code = vim.api.nvim_get_mode().mode:lower()
    local symbol = M.mode.map[code:sub(1, 2)] or M.mode.map[code:sub(1, 1)] or code
    return ' ' .. symbol .. ' '
  end

  return ' 󰒲 '
end

M.trailing_whitespace = function()
  local pattern = [[\s\+$]]
  local lineno = vim.fn.search(pattern, 'nwc')
  if lineno == 0 then
    return ''
  end

  local result = '·' .. lineno

  local info = vim.fn.searchcount { pattern = pattern }
  if info.total then
    result = result .. string.format(' Σ%d', info.total)
  end

  return result
end

M.colored_if_focused = function(component)
  if type(component) == 'string' then
    local c = require('lualine.components.' .. component):extend()

    function c:update_status(is_focused)
      self.options.colored = is_focused
      return c.super.update_status(self, is_focused)
    end

    return c
  elseif type(component) == 'function' then
    local c = require('lualine.component'):extend()

    function c:init(options)
      c.super.init(self, options)
      self.saved_hl = self.options.color_highlight
    end

    function c:update_status(is_focused)
      self.options.color_highlight = is_focused and self.saved_hl or nil
      return component(is_focused)
    end

    return c
  end
end

return M

