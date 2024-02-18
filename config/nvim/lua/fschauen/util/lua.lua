local M = {}

local util = require('fschauen.util')
local exists = util.exists

local find_module_sources = function(modname)
  modname = modname:gsub('^%.+', ''):gsub('/', '.')
  local base = 'lua/' .. modname:gsub('%.', '/')
  local candidates = { base .. '.lua', base .. '/init.lua' }

  local results = {}
  for _, directory in ipairs(vim.opt.runtimepath:get()) do
    for _, candidate in ipairs(candidates) do
      local path = directory .. '/' .. candidate
      if exists(path) then
        table.insert(results, path)
      end
    end
  end
  return results
end

M.execute_lines = function(first, last)
  first = first or vim.fn.line('.')
  last = last or first
  local code = vim.fn.join(vim.fn.getline(first, last), '\n')
  loadstring(code)()
end

M.execute_selection = function()
  local selection = { vim.fn.line('v'), vim.fn.line('.') }
  table.sort(selection)
  M.execute_lines(unpack(selection))
end

M.execute_file = function(path)
  if path then
    vim.cmd.luafile(path)
  else
    M.execute_lines(1, vim.fn.line('$'))
  end
end

M.go_to_module = function(modname)
  modname = modname or vim.fn.expand('<cfile>')

  local sources = find_module_sources(modname)
  if #sources == 0 then
    vim.notify('Not found: ' .. modname, vim.log.levels.WARN)
  elseif #sources == 1 then
    vim.cmd.edit(sources[1])
  else
    vim.ui.select(sources, { prompt = 'Which one?' }, function(choice)
      if choice then
        vim.cmd.edit(choice)
      end
    end)
  end
end

return M

