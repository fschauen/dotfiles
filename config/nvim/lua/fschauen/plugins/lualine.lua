local M = { 'nvim-lualine/lualine.nvim' }

local icons = require('fschauen.icons')
local orange = '#d65d0e'
local bright = '#ffffff'  -- alternative: '#f9f5d7'

M.dependencies = {
  'nvim-tree/nvim-web-devicons',
}

M.config = function()
  local window = require 'fschauen.window'

  local filename = (function()
    local C = require('lualine.component'):extend()

    function C:init(options)
      C.super.init(self, options)

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

    function C:update_status(is_focused)
      self.options.color_highlight = self.custom_highlights[is_focused][vim.bo.modified]

      local path = vim.fn.expand('%:~:.')

      if window.is_wide() then
        return path
      elseif window.is_medium() then
        return vim.fn.pathshorten(path)         -- only first letter of directories
      else
        return vim.fn.fnamemodify(path, ':t')   -- only tail
      end
    end

    return C
  end)()

  local mode = (function()
    local C = require('lualine.component'):extend()

    C.map = {
      ['n']  = icons.modes.Normal,          -- 'Normal ',    -- Normal
      ['no'] = icons.modes.OperatorPending, -- 'O-Pend ',    -- Operator-pending
      ['ni'] = icons.modes.NormalI,         -- 'Normal ',    -- Normal via i_CTRL-O
      ['v']  = icons.modes.Visual,          -- 'Visual ',    -- Visual by character
      [''] = icons.modes.VisualBlock,     -- 'V-Block',    -- Visual blockwise
      ['s']  = icons.modes.Select,          -- 'Select ',    -- Select by character
      [''] = icons.modes.SelectBlock,     -- 'S-Block',    -- Select blockwise
      ['i']  = icons.modes.Insert,          -- 'Insert ',    -- Insert
      ['r']  = icons.modes.Replace,         -- 'Replace',    -- Replace
      ['rv'] = icons.modes.VirtualReplace,  -- 'V-Repl ',    -- Virtual Replace
      ['c']  = icons.modes.Command,         -- 'Command',    -- Command-line
      ['cv'] = icons.modes.Ex,              -- '  Ex   ',    -- Ex mode
      ['rm'] = icons.modes.modeore,         -- ' modeore  ', -- -- modeORE --
      ['r?'] = icons.modes.Cofirm,          -- 'Confirm',    -- :confirm
      ['!']  = icons.modes.Shell,           -- ' Shell ',    -- External command executing
      ['t']  = icons.modes.Term,            -- ' Term  ',    -- Terminal
    }

    function C:update_status(is_focused)
      if not is_focused then return ' ' .. icons.ui.Sleep end

      local code = vim.api.nvim_get_mode().mode:lower()
      local symbol = C.map[code:sub(1, 2)] or C.map[code:sub(1, 1)] or code
      return ' ' .. symbol .. ' '
    end

    return C
  end)()

  local searchcount = (function()
    local C = require('lualine.component'):extend()

    function C:init(options)
      C.super.init(self, options)
      self.options = vim.tbl_extend('keep', self.options or {}, {
        maxcount = 999,
        timeout = 250,
      })
    end

    function C:update_status()
      if vim.v.hlsearch == 0 then return '' end

      local count = vim.fn.searchcount {
        maxcount = self.options.maxcount,
        timeout = self.options.timeout
      }
      if next(count) == nil then return '' end

      local denominator = count.total > count.maxcount and '' or string.format('%d', count.total)
      return string.format(icons.ui.Search .. '%d/%s', count.current, denominator)
    end

    return C
  end)()

  local colored_if_focused = function(component)
      if type(component) == 'string' then
      local C = require('lualine.components.' .. component):extend()

      function C:update_status(is_focused)
        self.options.colored = is_focused
        return C.super.update_status(self, is_focused)
      end

      return C

    elseif type(component) == 'function' then
      local C = require('lualine.component'):extend()

      function C:init(options)
        C.super.init(self, options)
        self.saved_hl = self.options.color_highlight
      end

      function C:update_status(is_focused)
        self.options.color_highlight = is_focused and self.saved_hl or nil
        return component(is_focused)
      end

      return C
    end
  end

  local trailing_whitespace = {
    colored_if_focused(function()
      local trailing = [[\s\+$]]
      local lineno = vim.fn.search(trailing, 'nwc')
      if lineno == 0 then return '' end

      local result = icons.ui.Attention .. lineno

      local total = vim.fn.searchcount({ pattern = trailing }).total
      if total > 1 then result = result .. string.format(' (%d total)', total) end

      return result
    end),

    color = { bg = orange },

    cond = function()
      return vim.bo.filetype ~= 'help'
    end,
  }

  local paste = {
    colored_if_focused(function(has_focus) return has_focus and icons.ui.Paste or '  ' end),
    color = {
      bg = orange,
    },
    cond = function() return vim.o.paste end
  }

  local status = {
    colored_if_focused(function(_)
      local status = ''
      if vim.bo.modified then status = status .. icons.ui.Modified end
      if vim.bo.readonly or not vim.bo.modifiable then status = status .. icons.ui.ReadOnly end
      return status
    end),
    color = {
      fg = bright,
    },
  }

  local sections = {
    lualine_a = {
      paste,
      mode
    },
    lualine_b = {
      { 'branch', icon = icons.git.Branch, cond = window.is_medium },
    },
    lualine_c = {
      filename,
      status,
    },
    lualine_x = {
      colored_if_focused('diagnostics'),
      searchcount,
      { colored_if_focused('filetype'), cond = window.is_medium },
    },
    lualine_y = {
      { 'fileformat', cond = window.is_medium },
      'progress',
    },
    lualine_z = {
      'location',
      trailing_whitespace,
    },
  }

  require('lualine').setup {
    options = {
      icons_enabled = true,
      component_separators = {
        left = '',
        right = ''
      },
      section_separators = {
        left = '',
        right = ''
      },
      theme = 'gruvbox',
    },
    sections = sections,
    inactive_sections = sections,
    extensions = {
      'fugitive',
      'quickfix',
      'nvim-tree',
      'lazy',
      'man',
      'trouble',
    },
  }
end

return M

