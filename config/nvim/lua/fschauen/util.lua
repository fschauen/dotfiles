local M = {}

M.file_exists = function(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

M.edit_file = function(path)
  if not pcall(vim.api.nvim_command, string.format('edit %s', path)) then
    vim.notify('Could not open ' .. path, vim.log.levels.ERROR)
  end
end

local find_module_source = function(modname)
  modname = modname:gsub('^%.+', ''):gsub('/', '.')
  local base = 'lua/' .. modname:gsub('%.', '/')
  local candidates = { base .. '.lua', base .. '/init.lua' }

  local results = {}
  for _, directory in ipairs(vim.opt.runtimepath:get()) do
    for _, candidate in ipairs(candidates) do
      local path = directory .. '/' .. candidate
      if M.file_exists(path) then
        table.insert(results, path)
      end
    end
  end
  return results
end

M.edit_lua_module = function(modname)
  local sources = find_module_source(modname)
  if #sources == 0 then
    vim.notify('Not found: ' .. modname, vim.log.levels.WARN)
  elseif #sources == 1 then
    M.edit_file(sources[1])
  else
    vim.ui.select(sources, { prompt = 'Which one?' }, function(choice)
      if choice then
        M.edit_file(choice)
      end
    end)
  end
end

return M

