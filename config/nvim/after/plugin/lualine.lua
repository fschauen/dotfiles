local MODE_MAP = {
  ['n']    = 'Normal ',
  ['no']   = 'O-Pend ',
  ['nov']  = 'O-Pend ',
  ['noV']  = 'O-Pend ',
  ['no'] = 'O-Pend ',
  ['niI']  = 'Normal ',
  ['niR']  = 'Normal ',
  ['niV']  = 'Normal ',
  ['nt']   = 'Normal ',
  ['v']    = 'Visual ',
  ['vs']   = 'Visual ',
  ['V']    = 'V-Line ',
  ['Vs']   = 'V-Line ',
  ['']   = 'V-Block',
  ['s']  = 'V-Block',
  ['s']    = 'Select ',
  ['S']    = 'S-Line ',
  ['']   = 'S-Block',
  ['i']    = 'Insert ',
  ['ic']   = 'Insert ',
  ['ix']   = 'Insert ',
  ['R']    = 'Replace',
  ['Rc']   = 'Replace',
  ['Rx']   = 'Replace',
  ['Rv']   = 'V-Repl ',
  ['Rvc']  = 'V-Repl ',
  ['Rvx']  = 'V-Repl ',
  ['c']    = 'Command',
  ['cv']   = '  Ex   ',
  ['ce']   = '  Ex   ',
  ['r']    = 'Replace',
  ['rm']   = '  More ',
  ['r?']   = 'Confirm',
  ['!']    = ' Shell ',
  ['t']    = ' Term  ',
}

local update_status = function(self, is_focused)
  self.options.colored = is_focused
  return self.super.update_status(self, is_focused)
end

local diff = require'lualine.components.diff':extend()
diff.update_status = update_status

local filetype = require'lualine.components.filetype':extend()
filetype.update_status = update_status

local window_is_at_least = function(width)
  return function()
    return vim.fn.winwidth(0) > width
  end
end

local window_is_wide   = window_is_at_least(80)
local window_is_medium = window_is_at_least(50)

local parts = {
  split = { function() return '%=' end, padding = 0 },

  mode = function()
    local code = vim.api.nvim_get_mode().mode
    return MODE_MAP[code] or code
  end,

  paste = {
    function() return '' end,
    color = { bg = '#bbaa00' },
    cond = function()
      return vim.opt.paste:get()
    end
  },

  visual_multi = function()
    local ok, infos = pcall(vim.fn.VMInfos)
    if not ok or not infos.status then return '' end
    return infos.current .. '/' .. infos.total .. ' ' .. infos.status
  end,

  branch = {
    'branch',
    icon = '',
    cond = window_is_wide,
  },

  diff = {
    diff,
    padding = 0,
    cond = window_is_wide,
  },

  path = function()
    local path = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.fnamemodify(path, ':~:.')

    if window_is_wide() then
      return filename
    elseif window_is_medium() then
      return vim.fn.pathshorten(filename)
    end

    return vim.fn.fnamemodify(filename, ':t')  -- only tail
  end,

  filetype = {
    filetype,
    cond = window_is_medium,
  },

  fileformat = {
    'fileformat',
    padding = { left = 0, right = 1 },
    cond = window_is_medium,
  },

  progress = {
    function()
      local chars = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }
      local current, total = vim.fn.line '.', vim.fn.line '$'
      return chars[math.ceil(#chars * current / total)]
    end,
    padding = { left = 0, right = 1 },
    cond = window_is_wide,
  },

  location = '%3l:%-2v',
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = { parts.visual_multi },
  lualine_c = { parts.branch, parts.diff, parts.split, parts.path },
  lualine_x = { 'diagnostics', parts.filetype, parts.fileformat, parts.progress },
  lualine_y = { parts.location },
  lualine_z = {},
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = 'solarized',
  },

  sections = vim.tbl_extend('force', inactive_sections, {
    lualine_a = { parts.mode, parts.paste },
  }),

  inactive_sections = inactive_sections,

  extensions = {
    'fugitive',
    'quickfix',
    'nvim-tree',
  }
}

