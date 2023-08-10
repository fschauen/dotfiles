local actions = require('fschauen.telescope').actions

local mappings = {
  ['<c-j>']    = actions.cycle_history_next,
  ['<c-k>']    = actions.cycle_history_prev,
  ['<s-down>'] = actions.preview_scrolling_down,
  ['<s-up>']   = actions.preview_scrolling_up,
  ['<c-y>']    = actions.cycle_layout_next,
  ['<c-o>']    = actions.toggle_mirror,
  ['<c-c>']    = actions.close,
  ['<c-q>']    = actions.smart_send_to_qflist_and_open,
  ['<c-l>']    = actions.smart_send_to_loclist_and_open,
  ['<c-b>']    = actions.smart_open_with_trouble
}

return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
              '&& cmake --build build --config Release ' ..
              '&& cmake --install build --prefix build'
    },
  },
  lazy = true,
  cmd = 'Telescope',
  keys = require('fschauen.keymap').telescope,
  opts  = {
    defaults = {
      mappings = {
        i = mappings,
        n = mappings,
      },

      prompt_prefix = '   ',     -- Alternatives:   ❯
      selection_caret = ' ',     -- Alternatives:   ➔  

      multi_icon = '󰄬 ',          -- Alternatives: 󰄬    
      scroll_strategy = 'limit',  -- Don't wrap around in results.

      dynamic_preview_title = true,

      layout_strategy = 'flex',
      layout_config = {
        width      = 0.9,
        height     = 0.9,
        flex       = { flip_columns   = 130 },
        horizontal = { preview_width  = 0.5, preview_cutoff = 130 },
        vertical   = { preview_height = 0.5 },
      },
      cycle_layout_list = { 'horizontal', 'vertical' },
    },
    pickers = {
      buffers = {
        mappings = {
          n = {
            x = actions.delete_buffer,
          },
        },
      },
      colorscheme = {
        theme = 'dropdown',
      },
      spell_suggest = {
        theme = 'cursor',
      },
    },
    extensions = {
      file_browser = {
        theme = 'ivy'
      },
    },
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension 'fzf'
    require('telescope').load_extension 'file_browser'
  end
}

