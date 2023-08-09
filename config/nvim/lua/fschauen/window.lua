M = {}

---Whether the current window is the last in a given direction.
---@param direction string: one of 'h', 'j', 'k', or 'l'
local is_last = function(direction)
  local current = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. direction)
  local next = vim.api.nvim_get_current_win()

  local is_last = current == next
  if not is_last then vim.cmd('wincmd p') end

  return is_last
end

---Resize current window in a given direction.
---@param dir string: one of 'h', 'j', 'k', or 'l'
---@param size integer: how much to resize
local resize = function(dir, size)
  if dir ~= 'h' and dir ~= 'j' and dir ~= 'k' and dir ~= 'l' then return end

  size = math.abs(size)
  local is_height = dir == 'j' or dir == 'k'
  local is_positive = dir == 'j' or dir == 'l'

  if is_last(is_height and 'j' or 'l') then
    is_positive = not is_positive
  end

  local delta = string.format('%s%d', is_positive and '+' or '-', size)
  local prefix = is_height and '' or 'vertical '
  vim.cmd(prefix .. 'resize ' .. delta .. '<cr>')
end

---Resize current window upwards.
---@param size integer: how much to resize
M.resize_up = function(size)
  return function()
    resize('k', size)
  end
end

---Resize current window downwards.
---@param size integer: how much to resize
M.resize_down = function(size)
  return function()
    resize('j', size)
  end
end

---Resize current window leftwards.
---@param size integer: how much to resize
M.resize_left = function(size)
  return function()
    resize('h', size)
  end
end

---Resize current window rightwards.
---@param size integer: how much to resize
M.resize_right = function(size)
  return function()
    resize('l', size)
  end
end

---Toggle quickfix (or location) list.
---@param qf string: 'c' for quickfix, 'l' for location list
local toggle_list = function(qf)
  local l = qf == 'l' and 1 or 0
  local is_qf = function(win) return win.quickfix == 1 and win.loclist == l end
  local is_open = not vim.tbl_isempty(vim.tbl_filter(is_qf, vim.fn.getwininfo()))
  if is_open then
    vim.cmd(qf .. 'close')
  else
    local ok = pcall(function(c) vim.cmd(c) end, qf .. 'open')
    if not ok and qf == 'l' then
      vim.notify('No location list', vim.log.levels.WARN)
    end
  end
end

---Toggle quickfix list.
M.toggle_quickfix = function()
  toggle_list('c')
end

---Toggle location list.
M.toggle_loclist = function()
  toggle_list('l')
end

return M

