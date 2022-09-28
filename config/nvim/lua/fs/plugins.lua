local packer = function()
  local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    local url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', url, path})
  end
  return require('packer')
end

return packer().startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  -- Visuals ----------------------------------------------------------------

  use {
    'tjdevries/colorbuddy.nvim',
    config = function() require'fs.solarized'.setup() end,
  }

  use 'kyazdani42/nvim-web-devicons'

  use {
    'nvim-lualine/lualine.nvim',
    config = function() require'fs.lualine'.config() end,
  }

  use {
    'lukas-reineke/virt-column.nvim',

    config = function()
      require'virt-column'.setup {
        char = '│'
      }

      -- show/hide virtual colorcolumn
      vim.keymap.set('n', '<leader>sc', function()
        if vim.o.colorcolumn == '' then
          vim.o.colorcolumn = '+1'
        else
          vim.o.colorcolumn = ''
        end
      end)
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',

    config = function()
      require'indent_blankline'.setup {
        enabled = false
      }

      -- show/hide indent guides
      vim.keymap.set('n', '<leader>si', '<cmd>:IndentBlanklineToggle<cr>')
    end,
  }

  use {
    'junegunn/rainbow_parentheses.vim',

    config = function()
      vim.g['rainbow#pairs'] = { {'(',')'}, {'[',']'}, {'{','}'} }

      -- show/hide rainbow parens
      vim.keymap.set('n', '<leader>sp', '<cmd>RainbowParentheses!!<cr>')
    end,
  }

  -- Navigation -------------------------------------------------------------

  use {
    'nvim-telescope/telescope.nvim',
    config = function() require'fs.telescope'.config() end,
  }

  use {
    'kyazdani42/nvim-tree.lua',

    config = function()
      require'nvim-tree'.setup {
        git = {
          ignore = false,       -- don't hide files from .gitignore
        },

        view = {
          width = 35,           -- a little wider than the default 30
        },

        filters = {
          dotfiles = false,     -- show files starting with a .
          custom = { '.git' },  -- don't show .git directory
        },

        renderer = {
          add_trailing = true,  -- add trailing / to folders
          group_empty = true,   -- folders that contain only one folder are grouped
          highlight_git = true, -- enable highlight based on git attributes
          indent_markers = {
            enable = true,      -- show indent markers
          },
        },
      }

      vim.keymap.set('n', '<c-n>',     '<cmd>NvimTreeToggle<cr>')
      vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>')
    end,
  }

  -- Editing ----------------------------------------------------------------

  use {
    'ntpeters/vim-better-whitespace',

    setup = function()
      vim.g.better_whitespace_filetypes_blacklist = {
        'diff',
        'fugitive',
        'git',
        'gitcommit',
        'help',
      }
    end,

    config = function()
      -- fix whitespace
      vim.keymap.set('n', '<leader>w', '<cmd>StripWhitespace<cr>')

      -- show/hide whitespace
      vim.keymap.set('n', '<leader>sw', '<cmd>ToggleWhitespace<cr>')
    end,
  }

  use 'godlygeek/tabular'

  use 'tpope/vim-commentary'

  -- git --------------------------------------------------------------------

  use {
    'tpope/vim-fugitive',

    config = function()
      vim.keymap.set('n', '<leader>gs', '<cmd>below Git<cr>')
      vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>')
    end,
  }

  -- Filetypes --------------------------------------------------------------

  use {
    'elzr/vim-json',

    setup = function()
      -- Disable quote concealling.
      vim.g.vim_json_syntax_conceal = 0
    end,

    config = function()
      -- Make numbers and booleans stand out.
      vim.cmd [[
        highlight link jsonBraces   Text
        highlight link jsonNumber   Identifier
        highlight link jsonBoolean  Identifier
        highlight link jsonNull     Identifier
      ]]
    end,
  }

  use {
    'plasticboy/vim-markdown',

    setup = function()
      -- Disable concealling on italic, bold, etc.
      vim.g.vim_markdown_conceal = 0

      -- Disable concealling on code blocks.
      vim.g.vim_markdown_conceal_code_blocks = 0

      -- Automatic insertion of bullets is buggy, so disable it.
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0
    end,

    config = function()
      local buf = { buffer = true }
      vim.keymap.set('n', '<leader>+', '<cmd>.,.HeaderIncrease<cr>', buf)
      vim.keymap.set('n', '<leader>=', '<cmd>.,.HeaderIncrease<cr>', buf)
      vim.keymap.set('n', '<leader>-', '<cmd>.,.HeaderDecrease<cr>', buf)
    end,
  }

  use 'keith/swift.vim'

  use 'chr4/nginx.vim'

  -- Misc -------------------------------------------------------------------

  use 'milisims/nvim-luaref'
end)

