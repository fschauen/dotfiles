local packer = (function()
  local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    local url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', url, path})
  end
  return require('packer')
end)()

vim.g.better_whitespace_filetypes_blacklist = {
  'diff',
  'fugitive',
  'git',
  'gitcommit',
  'help',
}

vim.g.vim_json_syntax_conceal = 0   -- Disable quote concealling.

vim.g.VM_leader = '\\'
vim.g.VM_silent_exit = 1

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'

  -- Visuals ----------------------------------------------------------------
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'lukas-reineke/virt-column.nvim'
  use 'lukas-reineke/indent-blankline.nvim'

  -- Navigation -------------------------------------------------------------
  use 'nvim-telescope/telescope.nvim'
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
  use 'elzr/vim-json'
  use 'keith/swift.vim'
  use 'chr4/nginx.vim'

  -- Misc -------------------------------------------------------------------
  use 'milisims/nvim-luaref'
end)

