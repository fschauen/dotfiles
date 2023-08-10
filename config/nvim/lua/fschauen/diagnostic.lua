local M = {}

local diag_opts = {
  wrap = false, -- don't wrap around the begin/end of file
}

---Move to the next diagnostic.
---@param opts table\nil: options passed along to `vim.diagnostic.goto_next`.
M.goto_next= function(opts)
  vim.diagnostic.goto_next(vim.tbl_extend('keep', opts or {}, diag_opts))
  vim.cmd 'normal zz'
end

---Move to the previous diagnostic.
---@param opts table|nil: options passed along to `vim.diagnostic.goto_prev`.
M.goto_prev= function(opts)
  vim.diagnostic.goto_prev(vim.tbl_extend('keep', opts or {}, diag_opts))
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

---Customize nvim's diagnostics display.
M.setup = function()
  vim.diagnostic.config {
    underline = false,
    virtual_text = {
      spacing = 6,
      prefix = '●',
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

