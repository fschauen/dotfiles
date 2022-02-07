local plugins = function(use)
    use 'wbthomason/packer.nvim'

    -- Visuals ----------------------------------------------------------------
    use 'altercation/vim-colors-solarized'
    use 'kyazdani42/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'

    -- Navigation -------------------------------------------------------------
    use 'kyazdani42/nvim-tree.lua'
    use 'junegunn/rainbow_parentheses.vim'
    use 'ctrlpvim/ctrlp.vim'

    -- Editing ----------------------------------------------------------------
    use 'bronson/vim-trailing-whitespace'
    use 'godlygeek/tabular'
    use 'tpope/vim-commentary'

    -- git --------------------------------------------------------------------
    use 'tpope/vim-fugitive'

    -- Filetypes --------------------------------------------------------------
    use 'elzr/vim-json'
    use 'plasticboy/vim-markdown'
    use 'keith/swift.vim'
    use 'chr4/nginx.vim'
    use 'vim-scripts/srec.vim'

    vim.cmd([[
        silent! colorscheme solarized
        highlight NonText cterm=NONE ctermfg=10     " subtle EOL symbols
        highlight Whitespace cterm=NONE ctermfg=9   " orange listchars
    ]])
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

