local builtin = require 'telescope.builtin'

local M = {}

function M.find_buffers()
  builtin.buffers { prompt_title = ' buffers ' }
end

function M.find_commits()
  builtin.git_commits { prompt_title = ' git commits ' }
end

function M.find_dotfiles()
  builtin.find_files {
    prompt_title = ' dotfiles',
    cwd = '~/.dotfiles',
  }
end

function M.find_files()
  builtin.find_files { prompt_title = ' files ' }
end

function M.find_help()
  builtin.help_tags { prompt_title = ' help tags ' }
end

function M.find_manpages()
  builtin.man_pages { prompt_title = ' man pages ' }
end

function M.find_options()
  builtin.vim_options {
    prompt_title = ' nvim options ',
    layout_config = {
      width = 0.75,
      height = 0.8,
    }
  }
end

return M

