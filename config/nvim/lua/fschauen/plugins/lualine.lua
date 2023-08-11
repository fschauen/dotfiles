local config = function()
  local MODES = {
    ['n']  = 'Normal ', -- Normal
    ['no'] = 'O-Pend ', -- Operator-pending
    ['ni'] = 'Normal ', -- Normal via i_CTRL-O
    ['v']  = 'Visual ', -- Visual by character
    ['V']  = 'V-Line ', -- Visual by line
    [''] = 'V-Block', -- Visual blockwise
    ['s']  = 'Select ', -- Select by character
    ['S']  = 'S-Line ', -- Select by line
    [''] = 'S-Block', -- Select blockwise
    ['i']  = 'Insert ', -- Insert
    ['R']  = 'Replace', -- Replace
    ['Rv'] = 'V-Repl ', -- Virtual Replace
    ['c']  = 'Command', -- Command-line
    ['cv'] = '  Ex   ', -- Ex mode
    ['rm'] = ' More  ', -- -- MORE --
    ['r?'] = 'Confirm', -- :confirm
    ['!']  = ' Shell ', -- External command executing
    ['t']  = ' Term  ', -- Terminal
  }

  local extend = function(component, overrides)
    local new = require(component):extend()
    for k, v in pairs(overrides) do new[k] = v end
    return new
  end

  local udpate_with_color = function(self, is_focused)
    self.options.colored = is_focused
    return self.super.update_status(self, is_focused)
  end

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

    diff = extend('lualine.components.diff', { update_status = udpate_with_color }),

    mode = {
      function()
        local code = vim.api.nvim_get_mode().mode
        return MODES[code:sub(1, 2):lower()] or MODES[code:sub(1, 1):lower()] or code
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
        local flags = vim.list_extend(
          vim.bo.modified and {'+'} or {},
          (vim.bo.readonly or not vim.bo.modifiable) and {'RO'} or {})
        return vim.fn.join(flags, ' ')
      end,

      color = { fg = '#eee8d5', gui = 'bold' },
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

      padding = { left = 1, right = 0},
    },

    filetype = {
      extend('lualine.components.filetype', { update_status = udpate_with_color }),
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
    lualine_c = { my.diff, my.filename, my.status },
    lualine_x = { my.filetype  },
    lualine_y = { my.fileformat, 'progress' },
    lualine_z = { 'location' },
  }


  local active_sections = vim.tbl_extend('force', inactive_sections, {
    lualine_a = vim.list_extend({ my.paste, my.mode }, inactive_sections.lualine_a),
    lualine_x = vim.list_extend({ 'diagnostics' }, inactive_sections.lualine_x),
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
      'lazy',
      'man',
      'trouble',
    },
  }
end

return {
  'nvim-lualine/lualine.nvim',
  config = config,
}

