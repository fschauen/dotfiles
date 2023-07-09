local config = function()
  local telescope      = require 'telescope'
  local actions        = require 'telescope.actions'
  local actions_layout = require 'telescope.actions.layout'
  local builtin        = require 'telescope.builtin'

  local mappings = {
    ['<c-l>'] = actions_layout.cycle_layout_next,
    ['<c-o>'] = actions_layout.toggle_mirror,
    ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
  }

  local mappings_normal_mode = mappings
  local mappings_insert_mode = vim.tbl_extend('force', mappings, {
    ['<c-j>'] = actions.cycle_history_next,
    ['<c-k>'] = actions.cycle_history_prev,
  })

  telescope.setup {
    defaults = {
      prompt_prefix = ' ❯ ',
      selection_caret = ' ',   -- Other ideas: ➔ 
      multi_icon = ' ',

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
        { layout_strategy = 'bottom_pane', layout_config = { width = 1, height = 0.4 }, },
        'horizontal',
        'vertical',
      },

      mappings = {
        i = mappings_insert_mode,
        n = mappings_normal_mode,
      },
    },

    pickers = {
      buffers     = { prompt_title = '   ﬘ Buffers   ' },
      find_files  = { prompt_title = '     Files    ' },
      git_commits = { prompt_title = '   Commits  ' },
      help_tags   = { prompt_title = '   Help tags  ' },
      keymaps     = { prompt_title = '    Keymaps   ' },
      live_grep   = { prompt_title = '   Live grep  ' },
      vim_options = { prompt_title = '  Vim options ' },
      man_pages   = { prompt_title = '   Man pages  ' },
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

  local selected_range = function()
    local _, s_row, s_col, _ = unpack(vim.fn.getpos('v'))
    local _, e_row, e_col, _ = unpack(vim.fn.getpos('.'))

    local mode = vim.api.nvim_get_mode().mode
    local visual_line = (mode == 'V' or mode == 'CTRL-V')

    if s_row < e_row or (s_row == e_row and s_col <= e_col) then
      if visual_line then s_col, e_col = 1, #vim.fn.getline(e_row) end
      return s_row - 1, s_col - 1, e_row - 1, e_col
    else
      if visual_line then e_col, s_col = 1, #vim.fn.getline(s_row) end
      return e_row - 1, e_col - 1, s_row - 1, s_col
    end
  end

  local selected_text = function()
    local r0, c0, r1, c1 = selected_range()
    return vim.fn.join(vim.api.nvim_buf_get_text(0, r0, c0, r1, c1, {}), '\n')
  end

  local custom = {
    all_files = function()
      builtin.find_files {
        prompt_title = '   ALL Files  ',
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      }
    end,

    dotfiles = function()
      builtin.find_files {
        prompt_title = '  Find dotfiles ',
        cwd = '~/.dotfiles',
        hidden = true,
      }
    end,

    grep_visual = function()
      local selection = selected_text()
      builtin.grep_string {
        prompt_title = string.format('  Grep: %s', selection),
        search = selection,
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
  map('n', '<leader>fh', builtin.help_tags,   { desc = ' [F]ind [H]elp tags' })
  map('n', '<leader>fk', builtin.keymaps,     { desc = ' [F]ind [K]eymaps' })
  map('n', '<leader>fm', custom.man_pages,    { desc = ' [F]ind [M]an pages' })
  map('n', '<leader>fo', builtin.vim_options, { desc = ' [F]ind vim [O]ptions' })
  map('n', '<leader>fs', builtin.grep_string, { desc = ' [F]ind [S]tring' })
  map('v', '<leader>fs', custom.grep_visual,  { desc = ' [F]ind visual [S]election' })
  map('n', '<leader>br', '<cmd>Telescope file_browser<cr>', { desc = ' file [BR]owser' })
end

return {
  'nvim-telescope/telescope.nvim',

  config = config,
  dependencies = {
    'nvim-telescope/telescope-file-browser.nvim',
  },
}

