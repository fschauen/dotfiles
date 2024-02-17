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

local find_lua_module_sources = function(modname)
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

local lua = {}

lua.execute_lines = function(first, last)
  first = first or vim.fn.line('.')
  last = last or first
  local code = vim.fn.join(vim.fn.getline(first, last), '\n')
  loadstring(code)()
end

lua.execute_selection = function()
  local selection = { vim.fn.line('v'), vim.fn.line('.') }
  table.sort(selection)
  lua.execute_lines(unpack(selection))
end

lua.execute_file = function(path)
  if path then
    vim.cmd.luafile(path)
  else
    lua.execute_lines(1, vim.fn.line('$'))
  end
end

lua.go_to_module = function(modname)
  modname = modname or vim.fn.expand('<cfile>')

  local sources = find_lua_module_sources(modname)
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

M.lua = lua

return M

