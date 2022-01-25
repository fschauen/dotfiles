local M = function(mode, lhs, rhs, opts)
    local merged_opts = vim.tbl_extend('keep', opts or {}, { noremap = true })
    local map = { mode = mode, lhs = lhs, rhs = rhs, opts = merged_opts }
    map.remap  = function() map.opts.noremap = false; return map end
    map.silent = function() map.opts.silent  = true;  return map end
    map.expr   = function() map.opts.expr    = true;  return map end
    map.unique = function() map.opts.unique  = true;  return map end
    map.nowait = function() map.opts.nowait  = true;  return map end
    map.script = function() map.opts.script  = true;  return map end
    return map
end

local register = function(maps)
    for _, m in ipairs(maps) do
        vim.api.nvim_set_keymap(m.mode, m.lhs, m.rhs, m.opts)
    end
end

vim.g.mapleader = ' '

register {
    -- better navigation for wrapped lines
    M('n', 'j', 'gj'),
    M('n', 'k', 'gk'),

    -- retain selection when indenting/unindenting in visual mode
    M('v', '>', '><cr>gv'),
    M('v', '<', '<<cr>gv'),

    -- easier window navigation
    M('n', '<c-j>', '<c-w>j'),
    M('n', '<c-k>', '<c-w>k'),
    M('n', '<c-h>', '<c-w>h'),
    M('n', '<c-l>', '<c-w>l'),

    -- window resizing
    M('n', '<Up>',    '<cmd>resize +1<cr>'),
    M('n', '<Down>',  '<cmd>resize -1<cr>'),
    M('n', '<Left>',  '<cmd>vertical resize -1<cr>'),
    M('n', '<Right>', '<cmd>vertical resize +1<cr>'),

    -- easier tab navigation
    M('n', '<c-n>', ':tabprevious<cr>').silent(),
    M('n', '<c-m>', ':tabnext<cr>'    ).silent(),

    -- move lines up and down
    M('n', '<A-j>',       [[:move .+1<cr>==]]     ).silent(),
    M('n', '<A-k>',       [[:move .-2<cr>==]]     ).silent(),
    M('v', '<A-j>',       [[:move '>+1<cr>gv=gv]] ).silent(),
    M('v', '<A-k>',       [[:move '<-2<cr>gv=gv]] ).silent(),
    M('i', '<A-j>',  [[<esc>:move .+1<cr>==gi]]   ).silent(),
    M('i', '<A-k>',  [[<esc>:move .-2<cr>==gi]]   ).silent(),

    -- cycle through line numbering modes
    M('n', '<leader>ln', ':set nonumber norelativenumber<CR>' ).silent(),
    M('n', '<leader>ll', ':set number norelativenumber<CR>'   ).silent(),
    M('n', '<leader>lr', ':set number relativenumber<CR>'     ).silent(),

    -- show list of buffers and prepare to switch
    M('n', '<leader>bf', ':ls<CR>:b<Space>'),

    -- quickly change background
    M('n', '<leader>bg', [[:let &background = &background ==? 'light' ? 'dark' : 'light'<cr>]]),

    -- disable highlight until next search
    M('n', '<leader>h', ':nohlsearch<cr>'),

    -- toggle NERDTree
    M('n', '<leader>n', ':NERDTreeToggle<cr>'),

    -- toggle rainbow parens
    M('n', '<leader>p', ':RainbowParentheses!!<cr>'),

    -- fix whitespace
    M('n', '<leader>w', ':FixWhitespace<cr>'),
}
