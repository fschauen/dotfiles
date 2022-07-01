local nmap = require'fs.util'.nmap

local setup = function()
  -- Disable concealling on italic, bold, etc.
  vim.g.vim_markdown_conceal = 0

  -- Disable concealling on code blocks.
  vim.g.vim_markdown_conceal_code_blocks = 0

  -- Automatic insertion of bullets is buggy. so disable it.
  vim.g.vim_markdown_auto_insert_bullets = 0
  vim.g.vim_markdown_new_list_item_indent = 0
end

local config = function()
  nmap { '<leader>+', '<cmd>.,.HeaderIncrease<cr>', { buffer = true } }
  nmap { '<leader>=', '<cmd>.,.HeaderIncrease<cr>', { buffer = true } }
  nmap { '<leader>-', '<cmd>.,.HeaderDecrease<cr>', { buffer = true } }
end

return { setup = setup, config = config }

