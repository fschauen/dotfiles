local plugins = function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  -- Visuals ----------------------------------------------------------------
  use {
    'altercation/vim-colors-solarized',
    config = function() require'fs.config.vim-colors-solarized'.config() end,
  }
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require'fs.config.lualine'.config() end,
  }
  use {
    'lukas-reineke/virt-column.nvim',
    config = function() require'fs.config.virt-column'.config() end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function() require'fs.config.indent-blankline'.config() end,
  }

  -- Navigation -------------------------------------------------------------
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require'fs.config.nvim-tree'.config() end,
  }
  use {
    'junegunn/rainbow_parentheses.vim',
    config = function() require'fs.config.rainbow_parentheses'.config() end,
  }
  use {
    'ctrlpvim/ctrlp.vim',
    setup = function() require'fs.config.ctrlp'.setup() end,
  }

  -- Editing ----------------------------------------------------------------
  use {
    'bronson/vim-trailing-whitespace',
    config = function() require'fs.config.vim-trailing-whitespace'.config() end,
  }
  use 'godlygeek/tabular'
  use 'tpope/vim-commentary'

  -- git --------------------------------------------------------------------
  use {
    'tpope/vim-fugitive',
    config = function() require'fs.config.vim-fugitive'.config() end,
  }

  -- Filetypes --------------------------------------------------------------
  use {
    'elzr/vim-json',
    setup = function() require'fs.config.vim-json'.setup() end,
    config = function() require'fs.config.vim-json'.config() end,
  }
  use {
    'plasticboy/vim-markdown',
    setup = function() require'fs.config.vim-markdown'.setup() end,
    config = function() require'fs.config.vim-markdown'.config() end,
  }
  use 'keith/swift.vim'
  use 'chr4/nginx.vim'
  use {
    'vim-scripts/srec.vim',
    config = function() require'fs.config.srec'.config() end,
  }
end

local packer = function()
  local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    local url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', url, path})
  end
  return require('packer')
end

return packer().startup(plugins)

