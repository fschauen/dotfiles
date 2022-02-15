local util = require 'fs.util'
local nmap = util.nmap

local actions = require 'telescope.actions'

local config = function()
  require'telescope'.setup {
    defaults = {
      prompt_prefix = '❯ ',
      selection_caret = '➔ ',

      layout_strategy = 'flex',
      layout_config = {
        anchor = 'center',
        width = 0.99,
        height = 0.99,

        horizontal = {
          preview_width = 0.6,
          preview_cutoff = 133,
        },

        vertical = {
          preview_height = 0.4,
        },

        flex = {
          flip_columns = 133,
        },
      },

      mappings = {
        i = {
          ['<c-j>'] = actions.cycle_history_next,
          ['<c-k>'] = actions.cycle_history_prev,
        },
      },
    },
  }

  nmap { '<leader>fb', [[<cmd>lua require'fs.telescope'.find_buffers()<cr>]] }
  nmap { '<leader>fc', [[<cmd>lua require'fs.telescope'.find_commits()<cr>]] }
  nmap { '<leader>fd', [[<cmd>lua require'fs.telescope'.find_dotfiles()<cr>]] }
  nmap { '<leader>ff', [[<cmd>lua require'fs.telescope'.find_files()<cr>]] }
  nmap { '<leader>fh', [[<cmd>lua require'fs.telescope'.find_help()<cr>]] }
  nmap { '<leader>fm', [[<cmd>lua require'fs.telescope'.find_manpages()<cr>]] }
  nmap { '<leader>fo', [[<cmd>lua require'fs.telescope'.find_options()<cr>]] }
end

return { config = config }

