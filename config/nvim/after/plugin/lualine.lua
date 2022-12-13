local ok, lualine = pcall(require, 'lualine')
if not ok or not lualine then
  return
end

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
  ['cv']   = 'Ex',
  ['ce']   = 'Ex',
  ['r']    = 'Replace',
  ['rm']   = 'More',
  ['r?']   = 'Confirm',
  ['!']    = 'Shell',
  ['t']    = 'Term',
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

local parts = {
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
    local ok, infos = pcall(vim.fn.VMInfos)
    if not ok or not infos.status then return '' end
    return infos.current .. '/' .. infos.total .. ' ' .. infos.status
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

  progress = {
    function()
      local chars = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }
      local current, total = vim.fn.line '.', vim.fn.line '$'
      return chars[math.ceil(#chars * current / total)]
    end,
    padding = { left = 0, right = 1 },
    cond = window_is_wide,
  },
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = { parts.visual_multi, parts.branch },
  lualine_c = { parts.filename, parts.status },
  lualine_x = { 'diagnostics', parts.filetype  },
  lualine_y = { parts.fileformat, parts.progress },
  lualine_z = { 'location' },
}

lualine.setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = 'solarized',
  },

  sections = vim.tbl_extend('force', inactive_sections, {
    lualine_a = { parts.paste, parts.mode },
  }),

  inactive_sections = inactive_sections,

  extensions = {
    'fugitive',
    'quickfix',
    'nvim-tree',
  }
}

