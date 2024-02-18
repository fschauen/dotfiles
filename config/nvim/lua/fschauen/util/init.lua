local M = {}

M.exists = function(path)
  local stat = vim.loop.fs_stat(path)
  return (stat and stat.type) or false
end

return M

