local function make_autocmds(groups)
  for name, commands in pairs(groups) do
    vim.cmd('augroup my_' .. name)
    vim.cmd('autocmd!')
    for _, item in ipairs(commands) do
      vim.cmd('autocmd ' .. table.concat(item, ' '))
    end
    vim.cmd('augroup END')
  end
end

make_autocmds {
  buffers = {
    -- Make it possible to use `gf` to jump to my configuration modules.
    { 'BufNewFile,BufRead', 'init.lua',
    "setlocal path+=~/.config/nvim/lua includeexpr=substitute(v:fname,'\\\\.','/','g')"},
  },
  windows = {
    -- Disable cursorline when entering Insert mode (but remember it)...
    { 'InsertEnter', '*',
      [[let w:had_cursorline=&cursorline | set nocursorline]] },
    -- ...and re-enable when leaving if it had been set before.
    { 'InsertLeave', '*',
      [[if exists('w:had_cursorline') | let &cursorline=w:had_cursorline | endif]] },
  },
  yank = {
    -- Briefly highlight yanked text.
    { 'TextYankPost', '*', 'silent! lua vim.highlight.on_yank()' },
  },
}

