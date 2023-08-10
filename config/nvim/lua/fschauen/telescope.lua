M = {}

local builtin = function() return require('telescope.builtin') end
local actions = function() return require('telescope.actions') end
local layout  = function() return require('telescope.actions.layout') end

M.actions = {
  cycle_history_next = function(...)
    actions().cycle_history_next(...)
  end,
  cycle_history_prev = function(...)
    actions().cycle_history_prev(...)
  end,
  preview_scrolling_down = function(...)
    actions().preview_scrolling_down(...)
  end,
  preview_scrolling_up = function(...)
    actions().preview_scrolling_up(...)
  end,
  cycle_layout_next = function(...)
    layout().cycle_layout_next(...)
  end,
  toggle_mirror = function(...)
    layout().toggle_mirror(...)
  end,
  close = function(...)
    actions().close(...)
  end,
  delete_buffer = function(...)
    actions().delete_buffer(...)
  end,
  smart_send_to_qflist_and_open = function(...)
    actions().smart_send_to_qflist(...)
    actions().open_qflist(...)
  end,
  smart_send_to_loclist_and_open = function(...)
    actions().smart_send_to_loclist(...)
    actions().open_loclist(...)
  end,
  smart_open_with_trouble = function(...)
    local trouble = vim.F.npcall(require, 'trouble.providers.telescope')
    if trouble then trouble.smart_open_with_trouble(...) end
  end,
}

local config_builtin = function(picker, opts)
  return function(title)
    return function()
      opts = opts or {}
      local args = vim.tbl_extend('keep', { prompt_title = title }, opts)
      builtin()[picker](args)
    end
  end
end

---Preserve register contents over function call.
---@param reg string: register to save, must be a valid register name.
---@param func function: function that may freely clobber the register.
---@return any: return value of calling `func`.
local with_saved_register = function(reg, func)
  local saved = vim.fn.getreg(reg)
  local result = func()
  vim.fn.setreg(reg, saved)
  return result
end

---Get selected text.
---@return string: selected text, or work under cursor if not in visual mode.
local get_selected_text = function()
  if vim.fn.mode() ~= 'v' then return vim.fn.expand '<cword>' end

  return with_saved_register('v', function()
    vim.cmd [[noautocmd sil norm "vy]]
    return vim.fn.getreg 'v'
  end)
end

M.pickers = setmetatable({
  all_files = config_builtin('find_files', {
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
  }),
  colorscheme = config_builtin('colorscheme', {
    enable_preview = true,
  }),
  diagnostics = config_builtin('diagnostics', {
    bufnr = 0
  }),
  dotfiles = config_builtin('find_files', {
    cwd = '~/.dotfiles',
    hidden = true,
  }),
  selection = function(_)
    return function()
      local text = get_selected_text()
      builtin().grep_string {
        prompt_title = string.format('    Grep: %s   ', text),
        search = text,
      }
    end
  end,
  here = config_builtin('current_buffer_fuzzy_find'),
}, {
  -- Fall back to telescope's built-in pickers if a custom one is not defined
  -- above, but make sure to keep the title we defined.
  __index = function(_, picker)
    return config_builtin(picker)
  end
})

return M

