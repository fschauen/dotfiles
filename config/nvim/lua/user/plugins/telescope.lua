local config = function()
  local telescope      = require 'telescope'
  local actions        = require 'telescope.actions'
  local actions_layout = require 'telescope.actions.layout'
  local builtin        = require 'telescope.builtin'

  local keymap = {
    ['<c-l>'] = actions_layout.cycle_layout_next,
    ['<c-o>'] = actions_layout.toggle_mirror,
    ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
    ['<c-c>'] = actions.close,

    ['<s-down>'] = actions.preview_scrolling_down,
    ['<s-up>']   = actions.preview_scrolling_up,

    ['<c-j>'] = actions.cycle_history_next,
    ['<c-k>'] = actions.cycle_history_prev,
  }

  local titles = {
    git_commits =               '   Commits  ',
    buffers     =               '    Buffers  ',
    find_files  =               '    Files  ',
    help_tags   =               '    Help tags  ',
    keymaps     =               '    Keymaps  ',
    live_grep   =               '    Live grep  ',
    vim_options =               '    Vim options  ',
    man_pages   =               '    Man pages  ',
    all_files   =               '    ALL Files  ',
    dotfiles    =               '    Find dotfiles ',
    grep        =               '    Grep: %s  ',
    treesitter  =               '    Treesitter Symbols',
    current_buffer_fuzzy_find = '    Current buffer',
  }

  telescope.setup {
    defaults = {
      prompt_prefix = ' ❯ ',
      selection_caret = ' ',   -- Other ideas: ➔ 
      multi_icon = ' ',

      scroll_strategy = 'limit',
      layout_strategy = 'flex',

      layout_config = {
        anchor = 'center',
        width = 0.9,
        height = 0.9,

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

      cycle_layout_list = {
        'horizontal',
        'vertical',
      },

      mappings = {
        i = keymap,
        n = keymap,
      },
    },

    pickers = {
      buffers                   = { prompt_title = titles.buffers     },
      find_files                = { prompt_title = titles.find_files  },
      git_commits               = { prompt_title = titles.git_commits },
      help_tags                 = { prompt_title = titles.help_tags   },
      keymaps                   = { prompt_title = titles.keymaps     },
      live_grep                 = { prompt_title = titles.live_grep   },
      vim_options               = { prompt_title = titles.vim_options },
      man_pages                 = { prompt_title = titles.man_pages   },
      treesitter                = { prompt_title = titles.treesitter  },
      current_buffer_fuzzy_find = { prompt_title = titles.current_buffer_fuzzy_find  },
    },

    extensions = {
      file_browser = {
        theme = 'ivy',
        mappings = {
          n = {
            -- normal mode mappings go here
          },
          i = {
            -- insert mode mappings go here
          },
        },
      },
    },
  }

  telescope.load_extension 'file_browser'
  telescope.load_extension 'fzf'

  local with_saved_register = function(register, func)
    local saved = vim.fn.getreg(register)
    local result = func()
    vim.fn.setreg(register, saved)
    return result
  end

  local get_selected_text = function()
    if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

    return with_saved_register('v', function()
      vim.cmd [[noautocmd sil norm "vy]]
      return vim.fn.getreg 'v'
    end)
  end

  local custom = {
    all_files = function()
      builtin.find_files {
        prompt_title = titles.all_files,
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      }
    end,

    dotfiles = function()
      builtin.find_files {
        prompt_title = titles.dotfiles,
        cwd = '~/.dotfiles',
        hidden = true,
      }
    end,

    grep = function()
      local selected = get_selected_text()
      builtin.grep_string {
        prompt_title = string.format(titles.grep, selected),
        search = selected,
      }
    end,

    man_pages = function()
      -- Fix for macOS Ventura onwards (macOS 13.x <-> Darwin 22.x).
      -- See: https://github.com/nvim-telescope/telescope.nvim/issues/2326#issuecomment-1407502328
      local uname = vim.loop.os_uname()
      local sysname = string.lower(uname.sysname)
      if sysname == "darwin" then
        local major_version = tonumber(vim.fn.matchlist(uname.release, [[^\(\d\+\)\..*]])[2]) or 0
        if major_version >= 22 then
          builtin.man_pages { sections = { 'ALL' }, man_cmd = { "apropos", "." } }
        else
          builtin.man_pages { sections = { 'ALL' }, man_cmd = { "apropos", " " } }
        end
      elseif sysname == "freebsd" then
        builtin.man_pages { sections = { 'ALL' }, man_cmd = { "apropos", "." } }
      else
        builtin.man_pages { sections = { 'ALL' } }
      end
    end,
  }

  local map = vim.keymap.set
  map('n', '<leader>fa', custom.all_files,    { desc = ' [F]ind [A]ll Files in $PWD' })
  map('n', '<leader>fb', builtin.buffers,     { desc = ' [F]ind [B]uffers' })
  map('n', '<leader>fc', builtin.git_commits, { desc = ' [F]ind [C]ommits' })
  map('n', '<leader>fd', custom.dotfiles,     { desc = ' [F]ind [D]otfiles' })
  map('n', '<leader>ff', builtin.find_files,  { desc = ' [F]ind [F]iles in $PWD' })
  map('n', '<leader>fg', builtin.live_grep,   { desc = ' [F]ind with [G]rep in $PWD' })
  map('n', '<leader>fh', builtin.current_buffer_fuzzy_find, { desc = ' [F]ind [H]ere' })
  map('n', '<leader>fk', builtin.keymaps,     { desc = ' [F]ind [K]eymaps' })
  map('n', '<leader>fm', custom.man_pages,    { desc = ' [F]ind [M]an pages' })
  map('n', '<leader>fo', builtin.vim_options, { desc = ' [F]ind vim [O]ptions' })
  map('n', '<leader>fs', custom.grep,         { desc = ' [F]ind [S]tring' })
  map('v', '<leader>fs', custom.grep,         { desc = ' [F]ind visual [S]election' })
  map('n', '<leader>ft', builtin.treesitter,  { desc = ' [F]ind [T]reesitter Symbols' })
  map('n', '<leader>f?', builtin.help_tags,   { desc = ' [F]ind Help tags [?]' })
  map('n', '<leader>br', '<cmd>Telescope file_browser<cr>', { desc = ' file [BR]owser' })
end

return {
  'nvim-telescope/telescope.nvim',

  config = config,
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ' ..
              '&& cmake --build build --config Release ' ..
              '&& cmake --install build --prefix build'
    },
  },
}

