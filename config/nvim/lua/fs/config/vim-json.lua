local setup = function()
  -- Disable quote concealling.
  vim.g.vim_json_syntax_conceal = 0
end

local config = function()
  -- Make numbers and booleans stand out.
  vim.cmd [[
    highlight link jsonBraces   Text
    highlight link jsonNumber   Identifier
    highlight link jsonBoolean  Identifier
    highlight link jsonNull     Identifier
  ]]
end

return { setup = setup, config = config }

