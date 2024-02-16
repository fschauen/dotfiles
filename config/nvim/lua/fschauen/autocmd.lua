local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup('fschauen', { clear = true } )

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Briefly highlight yanked text.',
    group = group,
    pattern = '*',
    callback = function(_) vim.highlight.on_yank() end
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    desc = 'Hide cursor line when entering insert mode.',
    group = group,
    pattern = '*',
    callback = function(_) vim.opt.cursorlineopt = 'number' end
  })

  vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Show cursor line when leaving insert mode.',
    group = group,
    pattern = '*',
    callback = function(_) vim.opt.cursorlineopt = 'both' end
  })

  local lua_go_to_file = function()
    require('fschauen.util').edit_lua_module(vim.fn.expand('<cfile>'))
  end

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Make `gf` work for lua modules.',
    group = group,
    pattern = 'lua',
    callback = function (_)
      vim.keymap.set('n', 'gf', lua_go_to_file, { buffer = 0 })
    end
  })
end

return M

