-- vim.g.better_whitespace_filetypes_blacklist = {
--   'diff',
--   'fugitive',
--   'git',
--   'gitcommit',
--   'help',
-- }

-- vim.g.VM_leader = '\\'
-- vim.g.VM_silent_exit = 1

return {
  'wbthomason/packer.nvim',
  'nvim-lua/plenary.nvim',

  -- Visuals ----------------------------------------------------------------
  { dir = '~/.dotfiles/plugins/solarized.nvim' },
  'kyazdani42/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',
  'lukas-reineke/virt-column.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'norcalli/nvim-colorizer.lua',

  -- Navigation -------------------------------------------------------------
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'kyazdani42/nvim-tree.lua',

  -- Editing ----------------------------------------------------------------
  'ntpeters/vim-better-whitespace',
  'godlygeek/tabular',
  'tpope/vim-commentary',
  -- 'mg979/vim-visual-multi',

  -- git --------------------------------------------------------------------
  'tpope/vim-fugitive',

  -- Treesitter -------------------------------------------------------------
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-refactor',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-treesitter/playground',

  -- Filetypes --------------------------------------------------------------
  'keith/swift.vim',
  'chr4/nginx.vim',

  -- Misc -------------------------------------------------------------------
  'milisims/nvim-luaref',
}
