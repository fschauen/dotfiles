-- Disable quote concealling.
vim.g.vim_json_syntax_conceal = 0

-- Make numbers and booleans stand out.
vim.cmd([[
  highlight link jsonBraces   Text
  highlight link jsonNumber   Identifier
  highlight link jsonBoolean  Identifier
  highlight link jsonNull     Identifier
]])

