local M = {}

local object = (function()
  local obj = {}
  obj.__index = obj

  function obj:init(...) end

  function obj:new(...)
    local new = setmetatable({}, self)
    new:init(...)
    return new
  end

  function obj:extend()
    local cls = {}
    cls.__index = cls
    cls.super = self
    return setmetatable(cls, self)
  end

  return obj
end)()

local segment = (function()
  local segment = object:extend()

  function segment:init(opts)
    self.opts = opts or {}
  end

  function segment:render()
    return self.opts
  end

  function segment.make(f)
    local new = segment:extend()
    function new:render(...) return f(...) end
    return new
  end

  return segment
end)()

local mode = (function()
  local mode = segment:extend()

  mode.map = {
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

  function mode:render()
    -- if not is_focused then return ' 󰒲 ' end -- TODO: handle inactive windows
    local code = vim.api.nvim_get_mode().mode:lower()
    local symbol = mode.map[code:sub(1, 2)] or mode.map[code:sub(1, 1)] or code
    return ' ' .. symbol .. ' '
  end

  return mode
end)()

-- FIX: actually find the branch
local branch = segment.make(function() return '󰘬 main' end)

local filename = segment.make(function() return vim.fn.expand('%:~:.') end)

local modified = segment.make(function() return vim.bo.modified and '' or '' end)

local readonly = segment.make(function() return (vim.bo.readonly or not vim.bo.modifiable) and '󰏯' or '' end)

local searchcount = segment.make(function()
  if vim.v.hlsearch == 1 then
    local count = vim.fn.searchcount { maxcount = 999, timeout = 250 }
    if count.total > 1 then
      return (' %d/%s'):format(
        count.current,
        count.total > count.maxcount and '' or ('%d'):format(count.total))
    end
  end
  return ''
end)

-- TODO: handle inactive windows
-- TODO: add icons
local filetype = segment.make(function() return vim.bo.filetype end)

local fileformat = segment.make(function()
  local icons = { unix = '', dos = '', mac = '' }
  return icons[vim.bo.fileformat] or vim.bo.fileformat
end)

local progress = segment.make(function()
  local line, total = vim.fn.line('.'), vim.fn.line('$')
  return
    line == 1 and ' 󰘣 ' or
    line == total and ' 󰘡 ' or
    ('%2d%%%%'):format(math.floor(100 * line / total))
end)

local location = segment.make(function() return ('%3d:%-2d'):format(vim.fn.line('.'), vim.fn.virtcol('.')) end)

local whitespace = segment.make(function()
  local trailing = [[\s\+$]]
  local line = vim.fn.search(trailing, 'nwc')
  if line == 0 then
    return ''
  else
    local result = (' %d'):format(line)
    local total = vim.fn.searchcount({ pattern = trailing }).total
    return result .. (total > 1 and (' (%d total)'):format(total) or '')
  end
end)

local literal = function(s) return segment.make(function() return s end) end

local defaults = {
  -- TODO: paste
  mode,
  branch,
  modified,
  readonly,
  filename,
  literal '%=',
  searchcount,
  literal '%=',
  -- TODO: diagnostics
  filetype,
  fileformat,
  progress,
  location,
  whitespace,
}

M.render = function()
  local rendered = vim.tbl_map(function(comp) return comp:render() end, defaults)
  local non_empty = vim.tbl_filter(function(item) return #item > 0 end, rendered)
  return vim.fn.join(non_empty, ' ')
end

M.setup = function()
  local colors = require('gruvbox').colors()
  vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.fg2, bg = colors.bg1 })

  -- vim.api.nvim_set_hl(0, 'TestlineNormal',  { fg = colors.bg0, bg = colors.blue })
  -- vim.api.nvim_set_hl(0, 'TestlineInsert',  { fg = colors.bg0, bg = colors.green })
  -- vim.api.nvim_set_hl(0, 'TestlineVisual',  { fg = colors.bg0, bg = colors.purple })
  -- vim.api.nvim_set_hl(0, 'TestlineReplace', { fg = colors.bg0, bg = colors.red })
  -- vim.api.nvim_set_hl(0, 'TestlineCommand', { fg = colors.bg0, bg = colors.yellow })

  vim.opt.statusline=[[%{%v:lua.require('testline').render()%}]]
end

return M

