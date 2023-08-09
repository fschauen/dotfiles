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
