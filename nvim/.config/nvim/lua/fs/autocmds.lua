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
    { 'BufNewFile,BufRead', 'bash_profile,bashrc,profile', 'set filetype=sh' },
    { 'BufNewFile,BufRead', 'gitconfig', 'set filetype=gitconfig' },
    { 'BufNewFile,BufRead', '*.sx,*.s19', 'set filetype=srec' },
    { 'BufNewFile,BufRead', 'Vagrantfile', 'set filetype=ruby' },
    -- Make it possible to use `gf` to jump to my configuration modules.
    { 'BufNewFile,BufRead', 'init.lua',
    "setlocal path+=~/.config/nvim/lua includeexpr=substitute(v:fname,'\\\\.','/','g')"},
  },
  windows = {
    -- Disable cursorline when entering Insert mode (but remember it)...
    { 'InsertEnter', '*', 'let g:stored_cursorline=&cursorline | set nocursorline' },
    -- ...and re-enable when leaving if it had been set before.
    { 'InsertLeave', '*', 'let &cursorline=g:stored_cursorline' },
  },
  yank = {
    -- Briefly highlight yanked text.
    { 'TextYankPost', '*', 'silent! lua vim.highlight.on_yank()' },
  },
}

