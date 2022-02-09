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
    b = Table:new { fg = colors.base03, bg = colors.base00 },
    c = Table:new { fg = colors.base1,  bg = colors.base02 },
  }

  local inactive = {
    a =           { fg = colors.base0,  bg = colors.base00 },
    b =           { fg = colors.base0,  bg = colors.base01 },
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

local parts = {
  paste = {
    function()
      return ''
    end,
    color = { fg = colors.base03, bg = colors.yellow, gui = 'bold' },
    cond = function()
      return vim.opt.paste:get()
    end
  },

  relative_path = {
    'filename',
    path = 1  -- 0: just filenane, 1: realtive path, 2: absolute path
  },

  encoding = function ()
    local fenc = vim.opt.fileencoding:get()
    if fenc ~= '' then
      return fenc
    end
    return vim.opt.encoding:get()
  end,

  fileformat = {
    'fileformat',
    padding = {
      left = 0,   -- otherise too sparse with icons
      right = 1,
    },
  },

  progress = '%3l/%L,%-2v',  -- line / total ｜column
}

local sections = Table:new {
  lualine_a = {},
  lualine_b = { 'branch' },
  lualine_c = { parts.relative_path },
  lualine_x = { 'diagnostics', 'filetype' },
  lualine_y = { parts.encoding, parts.fileformat },
  lualine_z = { parts.progress },
}

local config = function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      theme = theme,
    },

    sections = sections:override {
      lualine_a = { 'mode', parts.paste },
    },

    inactive_sections = sections,

    extensions = {
      'fugitive',
      'quickfix',
      'nvim-tree',
    }
  }
end

return { config = config }
