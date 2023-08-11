local M = {}

local window = require('fschauen.window')

local colored_when_focused = function(component)
  local new = require(component):extend()
  function new:update_status(is_focused)
    self.options.colored = is_focused
    return self.super.update_status(self, is_focused)
  end
  return new
end

local diff = colored_when_focused('lualine.components.diff')

local branch = {
  'branch',
  icon = '',
  cond = window.is_medium,
}

local fileformat = {
  'fileformat',
  cond = window.is_medium,
}

local filename = {
  function()
    local shorten_path = function(path)
      if window.is_wide() then
        return path
      elseif window.is_medium() then
        return vim.fn.pathshorten(path)         -- only first letter of directories
      else
        return vim.fn.fnamemodify(path, ':t')   -- only tail
      end
    end

    return shorten_path(vim.fn.expand('%:~:.'))
  end,

  padding = { left = 1, right = 0 },
}

local filetype = {
  colored_when_focused('lualine.components.filetype'),
  cond = window.is_medium,
}

local mode = {
  (function()
    local MODES = {
      ['n']  = '  ', -- 'Normal ', -- Normal
      ['no'] = '  ', -- 'O-Pend ', -- Operator-pending
      ['ni'] = '  ', -- 'Normal ', -- Normal via i_CTRL-O
      ['v']  = ' 󰒉 ', -- 'Visual ', -- Visual by character
      ['']  = ' 󰩭 ', -- 'V-Block', -- Visual blockwise
      ['s']  = ' 󰒉 ', -- 'Select ', -- Select by character
      ['']  = ' 󰩭 ', -- 'S-Block', -- Select blockwise
      ['i']  = '  ', -- 'Insert ', -- Insert
      ['r']  = ' 󰄾 ', -- 'Replace', -- Replace
      ['rv'] = ' 󰶻 ', -- 'V-Repl ', -- Virtual Replace
      ['c']  = '  ', -- 'Command', -- Command-line
      ['cv'] = '  ', -- '  Ex   ', -- Ex mode
      ['rm'] = '  ', -- ' More  ', -- -- MORE --
      ['r?'] = ' 󰭚 ', -- 'Confirm', -- :confirm
      ['!']  = '  ', -- ' Shell ', -- External command executing
      ['t']  = '  ', -- ' Term  ', -- Terminal
    }
    return function()
      local code = vim.api.nvim_get_mode().mode
      return MODES[code:sub(1, 2):lower()] or MODES[code:sub(1, 1):lower()] or code
    end
  end)()
}

local paste = {
  function() return '' end,
  color = { bg = '#fe8019' },
  cond = function() return vim.opt.paste:get() end
}

local status = {
  function()
    local flags = vim.list_extend(
      vim.bo.modified and { '+' } or {},
      (vim.bo.readonly or not vim.bo.modifiable) and { 'RO' } or {})
    return vim.fn.join(flags, ' ')
  end,

  color = {
    fg = '#eee8d5',
    gui = 'bold'
  },
}

local visual_multi = function()
  local info = vim.F.npcall(vim.fn.VMInfos)
  if info and info.status then
    return info.current .. '/' .. info.total .. ' ' .. info.status
  else
    return ''
  end
end

local default = {
  lualine_a = {},
  lualine_b = { visual_multi, branch },
  lualine_c = { diff, filename, status },
  lualine_x = { filetype },
  lualine_y = { fileformat, 'progress' },
  lualine_z = { 'location' },
}

M.sections = {
  inactive = default,
  active = vim.tbl_extend('force', default, {
    lualine_a = vim.list_extend({ paste, mode }, default.lualine_a),
    lualine_x = vim.list_extend({ 'diagnostics' }, default.lualine_x),
  })
}

return M

