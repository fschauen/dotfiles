local colorscheme = function(tbl)
  return vim.tbl_deep_extend('keep', tbl, { lazy = false, priority = 1000 })
end

return {
  colorscheme { 'fschauen/gruvbox.nvim', dev = true },
  colorscheme { 'fschauen/solarized.nvim', dev = true },

  colorscheme { 'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      flavor = 'mocha',
      show_end_of_buffer = true,
      dim_inactive = { enabled = true },
      integrations = { notify = true },
      custom_highlights = function(colors)
        local extra_dark = false
        return extra_dark
          and {
            Normal     = { bg = colors.crust },
            CursorLine = { bg = colors.mantle },
          }
          or {}
      end,
    },
  },

  colorscheme { 'rebelot/kanagawa.nvim',
    opts = {
      dimInactive = true,
      theme = 'dragon',
      overrides = function(colors)
        local palette = colors.palette
        return {
          Normal       = { bg = palette.sumiInk2 },
          CursorLine   = { bg = palette.sumiInk3 },
          LineNr       = { bg = palette.sumiInk2 },
          CursorLineNr = { bg = palette.sumiInk2 },
          SignColumn   = { bg = palette.sumiInk2 },
        }
      end,
    },
  },

  colorscheme { 'folke/tokyonight.nvim',
    opts = {
      style = 'night',
      dim_inactive = true,
      on_colors = function(colors)
        colors.bg_highlight = '#1d212f'
      end,
    },
  },
}

