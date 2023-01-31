local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then return end

local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

local common_mappings = {
  ['<c-l>'] = actions_layout.cycle_layout_next,
  ['<c-o>'] = actions_layout.toggle_mirror,
  ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
}

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
      i = vim.tbl_extend('force', common_mappings, {
        ['<c-j>'] = actions.cycle_history_next,
        ['<c-k>'] = actions.cycle_history_prev,
      }),
      n = common_mappings,
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

local builtin = require 'telescope.builtin'

local custom = {
  dotfiles = function()
    builtin.find_files {
      prompt_title = '  Find dotfiles ',
      cwd = '~/.dotfiles',
      hidden = true,
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

map('n', '<leader>fb', builtin.buffers,     { desc = ' [F]ind [B]uffers' })
map('n', '<leader>fc', builtin.git_commits, { desc = ' [F]ind [C]ommits' })
map('n', '<leader>fd', custom.dotfiles,     { desc = ' [F]ind [D]otfiles' })
map('n', '<leader>ff', builtin.find_files,  { desc = ' [F]ind [F]iles in $PWD' })
map('n', '<leader>fg', builtin.live_grep,   { desc = ' [F]ind with [G]rep in $PWD' })
map('n', '<leader>fh', builtin.help_tags,   { desc = ' [F]ind [H]elp tags' })
map('n', '<leader>fk', builtin.keymaps,     { desc = ' [F]ind [K]eymaps' })
map('n', '<leader>fm', custom.man_pages,    { desc = ' [F]ind [M]an pages' })
map('n', '<leader>fo', builtin.vim_options, { desc = ' [F]ind vim [O]ptions' })



local loaded_file_browser, _ = pcall(telescope.load_extension, 'file_browser')
if loaded_file_browser then
  map('n', '<leader>br', '<cmd>Telescope file_browser<cr>', { desc = ' file [BR]owser' })
else
  vim.notify('Telescope file_browser not installed!', vim.log.levels.WARN)
end

