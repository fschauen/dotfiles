local Table = {
  new = function (self, tbl)
    tbl = setmetatable(tbl or {}, self)
    self.__index = self
    return tbl
  end,

  override = function(self, tbl)
    return vim.tbl_extend('force', self, tbl)
  end
}

local colors = require'fs.util'.colors()

local theme = (function()
  local active = {
    a = Table:new { fg = colors.base03, bg = colors.base1  },
    b = Table:new { fg = colors.base03, bg = colors.base0  },
    c = Table:new { fg = colors.base1,  bg = colors.base02 },
  }

  local inactive = {
    a =           { fg = colors.base02, bg = colors.base00 },
    b =           { fg = colors.base02, bg = colors.base01 },
    c =           { fg = colors.base01, bg = colors.base03 },
  }

  return {
    normal = {
      a = active.a:override { bg = colors.blue },
      b = active.b,
      c = active.c,
    },
    insert = {
      a = active.a:override { bg = colors.green },
    },
    visual = {
      a = active.a:override { bg = colors.magenta },
    },
    replace = {
      a = active.a:override { bg = colors.red },
    },
    inactive = {
      a = inactive.a,
      b = inactive.b,
      c = inactive.c,
    },
  }
end)()

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
    color = { fg = colors.base03, bg = colors.yellow, gui = 'bold' },
    cond = function()
      return vim.opt.paste:get()
    end
  },

  branch = {
    'branch',
    icon = '',
    cond = window_is_wide,
  },

  diff = {
    diff,
    diff_color = {
      added    = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed  = { fg = colors.orange },
    },
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
  -- function()
  --   return vim.fn.pathshorten(vim.fn.fnamemodify(vim.fn.expand('%'), ':p'))
  -- end,

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
    color = {
      fg = theme.normal.b.bg,
      bg = theme.normal.c.bg,
    },
    cond = window_is_wide,
  },

  location = '%3l:%-2v',
}

local sections = Table:new {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { parts.branch, parts.diff, parts.split, parts.path },
  lualine_x = { 'diagnostics', parts.filetype, parts.fileformat, parts.progress },
  lualine_y = { parts.location },
  lualine_z = {},
}

local config = function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      theme = theme,
    },

    sections = sections:override { lualine_a = { parts.mode, parts.paste } },

    inactive_sections = sections,

    extensions = {
      'fugitive',
      'quickfix',
      'nvim-tree',
    }
  }
end

return { config = config }
