local plugins = function(use)
    use 'wbthomason/packer.nvim'

    use 'altercation/vim-colors-solarized'
    use 'bronson/vim-trailing-whitespace'
    use 'elzr/vim-json'
            -- Disable quote concealling.
            vim.g.vim_json_syntax_conceal = 0
            -- Make numbers and booleans stand out.
            vim.cmd([[
                highlight link jsonBraces   Text
                highlight link jsonNumber   Identifier
                highlight link jsonBoolean  Identifier
                highlight link jsonNull     Identifier
            ]])

    use 'godlygeek/tabular'
    use 'plasticboy/vim-markdown'
        vim.g.vim_markdown_conceal_code_blocks = 0

    use 'junegunn/rainbow_parentheses.vim'
        vim.g['rainbow#pairs'] = { {'(',')'}, {'[',']'}, {'{','}'} }

    use 'ctrlpvim/ctrlp.vim'
        vim.g.ctrlp_match_window  = 'bottom,order:ttb'
        vim.g.ctrlp_switch_buffer = 0   -- open files in new buffer
        vim.g.ctrlp_show_hidden   = 1   -- show hidden files

    use { 'scrooloose/nerdtree', cmd = 'NERDTreeToggle' }
    use 'tpope/vim-commentary'
    use 'itchyny/lightline.vim'
    use 'vim-scripts/srec.vim'
        vim.cmd([[
            highlight link srecStart        Comment
            highlight link srecType         Comment
            highlight link srecLength       WarningMsg
            highlight link srec16BitAddress Constant
            highlight link srec24BitAddress Constant
            highlight link srec32BitAddress Constant
            highlight link srecChecksum     Type
        ]])

    use 'keith/swift.vim'
    use 'chr4/nginx.vim'

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

