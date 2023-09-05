local M = {}

-- Show/navigate warning and errors by default.
M.severity = vim.diagnostic.severity.WARN

-- Make options to pass to goto_next()/goto_prev(). This needs to be a function
-- rather than just a table bevause M.severity can change and we always want the
-- *current* value.
local make_opts = function(opts)
  local defaults = {
    wrap = false,         -- don't wrap around the begin/end of file
    severity = {          -- only navigate items with visible virtual text
      min = M.severity
    },
  }
  return vim.tbl_extend('keep', opts or {}, defaults)
end

---Move to the next diagnostic.
---@param opts table\nil: options passed along to `vim.diagnostic.goto_next`.
M.goto_next= function(opts)
  vim.diagnostic.goto_next(make_opts(opts))
  vim.cmd 'normal zz'
end

---Move to the previous diagnostic.
---@param opts table|nil: options passed along to `vim.diagnostic.goto_prev`.
M.goto_prev= function(opts)
  vim.diagnostic.goto_prev(make_opts(opts))
  vim.cmd 'normal zz'
end

---Show diagnostics in a floating window.
---@param opts table|nil: options passed along to `vim.diagnostic.open_float`.
M.open_float= function(opts)
  vim.diagnostic.open_float(opts)
end

---Toggle diagnostics in the given buffer.
---@param bufnr integer|nil: Buffer number (0 for current buffer, nil for all buffers.
M.toggle = function(bufnr)
  bufnr = bufnr or 0
  if vim.diagnostic.is_disabled(bufnr) then
    vim.diagnostic.enable(bufnr)
  else
    vim.diagnostic.disable(bufnr)
  end
end

---Hide currently displayed diagnostics.
---@param bufnr integer|nil: Buffer number (0 for current buffer, nil for all buffers.
M.hide = function(bufnr)
  vim.diagnostic.hide(nil, bufnr or 0)
end

M.select_virtual_text_severity = function()
  vim.ui.select(
    { 'ERROR', 'WARN', 'INFO', 'HINT' },
    { prompt = 'Min. severity for virtual text:' },
    function(choice, --[[index]]_)
      if choice then
        M.severity = vim.diagnostic.severity[choice] or M.severity
        vim.diagnostic.config {
          virtual_text = {
            severity = { min = M.severity }
          },
        }
      end
    end)
end

---Customize nvim's diagnostics display.
M.setup = function()
  vim.diagnostic.config {
    underline = false,
    virtual_text = {
      spacing = 6,
      prefix = '●',
      severity = {
        min = M.severity,
      }
    },
    float = {
      border = 'rounded',
    },
    severity_sort = true,
  }

  local signs = {
    Error = ' ',
    Warn = ' ',
    Info = ' ',
    Hint = ' ',
  }

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

return M

