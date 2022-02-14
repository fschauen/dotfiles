local builtin = require 'telescope.builtin'

local M = {}

function M.find_buffers()
  builtin.buffers { prompt_title = ' BUFFERS ' }
end

function M.find_commits()
  builtin.git_commits { prompt_title = ' GIT COMMITS ' }
end

function M.find_dotfiles()
  builtin.find_files {
    prompt_title = ' dotfiles',
    cwd = '~/.dotfiles',
  }
end

function M.find_files()
  builtin.find_files { prompt_title = ' FILES ' }
end

function M.find_help()
  builtin.help_tags { prompt_title = ' HELP TAGS ' }
end

function M.find_manpages()
  builtin.man_pages { prompt_title = ' MAN PAGES ' }
end

function M.find_options()
  builtin.vim_options {
    prompt_title = ' NVIM OPTIONS ',
    layout_config = {
      width = 0.75,
      height = 0.8,
    }
  }
end

return M

