vim.g.better_whitespace_filetypes_blacklist = {
  'diff',
  'fugitive',
  'git',
  'gitcommit',
  'help',
}

vim.g.VM_leader = '\\'
vim.g.VM_silent_exit = 1

local bootstrap_packer = function()
  local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    local url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', url, path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_did_bootstrap = bootstrap_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Visuals ----------------------------------------------------------------
  use '~/.dotfiles/plugins/solarized.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'lukas-reineke/virt-column.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'norcalli/nvim-colorizer.lua'

  -- Navigation -------------------------------------------------------------
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'kyazdani42/nvim-tree.lua'

  -- Editing ----------------------------------------------------------------
  use 'ntpeters/vim-better-whitespace'
  use 'godlygeek/tabular'
  use 'tpope/vim-commentary'
  -- use 'mg979/vim-visual-multi'

  -- git --------------------------------------------------------------------
  use 'tpope/vim-fugitive'

  -- Treesitter -------------------------------------------------------------
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'

  -- Filetypes --------------------------------------------------------------
  use 'keith/swift.vim'
  use 'chr4/nginx.vim'

  -- Misc -------------------------------------------------------------------
  use 'milisims/nvim-luaref'

  if packer_did_bootstrap then require('packer').sync() end
end)
