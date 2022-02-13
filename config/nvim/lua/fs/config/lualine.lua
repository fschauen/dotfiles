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
    b = Table:new { fg = colors.base03, bg = colors.base0 },
    c = Table:new { fg = colors.base1,  bg = colors.base02 },
  }

  local inactive = {
    a =           { fg = colors.base02, bg = colors.base00 },
    b =           { fg = colors.base02, bg = colors.base01 },
    c =           { fg = colors.base01, bg = colors.base02 },
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

local update_status = function(self, is_focused)
  self.options.colored = is_focused
  return self.super.update_status(self, is_focused)
end

local diff = require'lualine.components.diff':extend()
diff.update_status = update_status

local filetype = require'lualine.components.filetype':extend()
filetype.update_status = update_status

local path = function()
  return vim.fn.pathshorten(vim.fn.fnamemodify(vim.fn.expand('%'), ':p'))
end

local parts = {
  split = function() return '%=' end,

  mode = 'mode',

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
  },

  diff = {
    diff,
    diff_color = {
      added    = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed  = { fg = colors.orange },
    },
    padding = 0,
  },

  path = path,

  filetype = filetype,

  location = '%3l:%-2v',

  progress = {
    function()
      local chars = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁', ' ' }
      local current, total = vim.fn.line '.', vim.fn.line '$'
      return chars[math.ceil(#chars * current / total)]
    end,
    padding = 0,
    color = {
      fg = theme.normal.b.bg,
      bg = theme.normal.c.bg,
    },
  },
}

local sections = Table:new {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { parts.branch, parts.diff, parts.split, parts.path },
  lualine_x = { 'diagnostics', parts.filetype, 'fileformat' },
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
