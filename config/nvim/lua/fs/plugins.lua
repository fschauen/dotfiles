local plugins = function(use)
    use 'wbthomason/packer.nvim'

    -- Visuals ----------------------------------------------------------------
    use {
      'altercation/vim-colors-solarized',
      config = [[require'fs.config.vim-colors-solarized'.config()]],
    }
    use 'kyazdani42/nvim-web-devicons'
    use {
      'nvim-lualine/lualine.nvim',
      config = [[require'fs.config.lualine'.config()]],
    }

    -- Navigation -------------------------------------------------------------
    use {
      'kyazdani42/nvim-tree.lua',
      config = [[require'fs.config.nvim-tree'.config()]],
    }
    use {
      'junegunn/rainbow_parentheses.vim',
      config = [[require'fs.config.rainbow_parentheses'.config()]],
    }
    use {
      'ctrlpvim/ctrlp.vim',
      setup = [[require'fs.config.ctrlp'.setup()]],
    }

    -- Editing ----------------------------------------------------------------
    use {
      'bronson/vim-trailing-whitespace',
      config = [[require'fs.config.vim-trailing-whitespace'.config()]],
    }
    use 'godlygeek/tabular'
    use 'tpope/vim-commentary'

    -- git --------------------------------------------------------------------
    use {
      'tpope/vim-fugitive',
      config = [[require'fs.config.vim-fugitive'.config()]],
    }

    -- Filetypes --------------------------------------------------------------
    use {
      'elzr/vim-json',
      setup = [[require'fs.config.vim-json'.setup()]],
      config = [[require'fs.config.vim-json'.config()]],
    }
    use {
      'plasticboy/vim-markdown',
      setup = [[require'fs.config.vim-markdown'.setup()]],
      config = [[require'fs.config.vim-markdown'.config()]],
    }
    use 'keith/swift.vim'
    use 'chr4/nginx.vim'
    use {
      'vim-scripts/srec.vim',
      config = [[require'fs.config.srec'.config()]],
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

