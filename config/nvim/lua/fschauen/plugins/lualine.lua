local config = function()
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
    ['ntT']  = 'Normal*',
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
    ['rm']   = ' More  ',
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
    return function() return vim.fn.winwidth(0) > width end
  end

  local window_is_wide   = window_is_at_least(80)
  local window_is_medium = window_is_at_least(50)

  local my = {
    paste = {
      function() return '' end,
      color = { bg = '#bbaa00' },
      cond = function()
        return vim.opt.paste:get()
      end
    },

    mode = {
      function()
        local code = vim.api.nvim_get_mode().mode
        return MODE_MAP[code] or code
      end,
    },

    visual_multi = function()
      local info = vim.F.npcall(vim.fn.VMInfos)
      if info and info.status then
        return info.current .. '/' .. info.total .. ' ' .. info.status
      else
        return ''
      end
    end,

    branch = {
      'branch',
      icon = '',
      cond = window_is_medium,
    },

    status = {
      function()
        local flags = {}
        if vim.bo.modified then
          table.insert(flags, '+')
        end
        if vim.bo.modifiable == false or vim.bo.readonly == true then
          table.insert(flags, 'RO')
        end
        return table.concat(flags, ' ')
      end,

      color = { fg = '#eee8d5' },
    },

    filename = {
      function()
        local shorten_path = function(path)
          if window_is_wide() then
            return path
          elseif window_is_medium() then
            return vim.fn.pathshorten(path)  -- only first letter of directories
          else
            return vim.fn.fnamemodify(path, ':t')  -- only tail
          end
        end

        return shorten_path(vim.fn.expand('%:~:.'))
      end,

      color = function()
        if vim.bo.modified then
          return { gui = 'italic' }
        end
      end,

      padding = { left = 1, right = 0},
    },

    filetype = {
      filetype,
      cond = window_is_medium,
    },

    fileformat = {
      'fileformat',
      cond = window_is_medium,
    },
  }

  local inactive_sections = {
    lualine_a = {},
    lualine_b = { my.visual_multi, my.branch },
    lualine_c = { diff, my.filename, my.status },
    lualine_x = { my.filetype  },
    lualine_y = { my.fileformat, 'progress' },
    lualine_z = { 'location' },
  }

  local concat = require('fschauen.util').concat

  local active_sections = vim.tbl_extend('force', inactive_sections, {
    lualine_a = concat({ my.paste, my.mode }, inactive_sections.lualine_a),
    lualine_x = concat({ 'diagnostics' }, inactive_sections.lualine_x),
  })

  require('lualine').setup {
    options = {
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      theme = 'gruvbox',
    },

    sections = active_sections,
    inactive_sections = inactive_sections,

    extensions = {
      'fugitive',
      'quickfix',
      'nvim-tree',
    }
  }
end

return {
  'nvim-lualine/lualine.nvim',
  config = config,
}

