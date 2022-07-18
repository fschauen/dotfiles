local util = require 'fs.util'
local nmap = util.nmap

local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

local M = {}

M.find_buffers = function()
  builtin.buffers { prompt_title = ' ﬘ Find buffers ' }
end

M.find_commits = function()
  builtin.git_commits { prompt_title = '  Find git commits ' }
end

M.find_dotfiles = function()
  builtin.find_files {
    prompt_title = '  Find dotfiles ',
    cwd = '~/.dotfiles',
    hidden = true,
  }
end

M.find_files = function()
  builtin.find_files { prompt_title = '  Find files  ' }
end

M.find_help = function()
  builtin.help_tags { prompt_title = ' ﬤ Find help tags ' }
end

M.find_manpages = function()
  builtin.man_pages {
    prompt_title = '  Find man pages ',
    sections = { 'ALL' },
  }
end

M.find_options = function()
  builtin.vim_options {
    prompt_title = '  Find nvim options ',
    layout_config = {
      width = 0.75,
      height = 0.8,
    }
  }
end

M.config = function()
  require'telescope'.setup {
    defaults = {
      prompt_prefix = '❯ ',
      selection_caret = '➔ ',

      layout_strategy = 'flex',
      layout_config = {
        anchor = 'center',
        width = 0.92,
        height = 0.95,

        flex = {
          flip_columns = 130,
        },

        horizontal = {
          preview_width = 0.5,
          preview_cutoff = 130,
        },

        vertical = {
          preview_height = 0.5,
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

  nmap { '<leader>fb', [[<cmd>lua require'fs.config.telescope'.find_buffers()<cr>]] }
  nmap { '<leader>fc', [[<cmd>lua require'fs.config.telescope'.find_commits()<cr>]] }
  nmap { '<leader>fd', [[<cmd>lua require'fs.config.telescope'.find_dotfiles()<cr>]] }
  nmap { '<leader>ff', [[<cmd>lua require'fs.config.telescope'.find_files()<cr>]] }
  nmap { '<leader>fh', [[<cmd>lua require'fs.config.telescope'.find_help()<cr>]] }
  nmap { '<leader>fm', [[<cmd>lua require'fs.config.telescope'.find_manpages()<cr>]] }
  nmap { '<leader>fo', [[<cmd>lua require'fs.config.telescope'.find_options()<cr>]] }
end

return M

