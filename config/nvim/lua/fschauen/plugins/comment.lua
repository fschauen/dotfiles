return {
  'numToStr/Comment.nvim',

  config = function()
    require('Comment').setup {
      padding = true, -- Add a space between comment and the line
      sticky = true, -- Whether the cursor should stay at its position
      ignore = nil, -- Lines to be ignored while (un)comment

      -- NORMAL mode mappings
      toggler = {
        line = 'gcc', -- Line-comment toggle keymap
        block = 'gbc', -- Block-comment toggle keymap
      },

      -- NORMAL and VISUAL mode mappings
      opleader = {
        line = 'gc', -- Line-comment keymap
        block = 'gb', -- Block-comment keymap
      },

      extra = {
        above = 'gcO', -- Add comment on the line above
        below = 'gco', -- Add comment on the line below
        eol = 'gcA', -- Add comment at the end of line
      },

      -- Enable keybindings
      mappings = {
        basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        extra = true, -- Extra mapping; `gco`, `gcO`, `gcA`
      },

      pre_hook = nil, -- Function to call before (un)comment
      post_hook = nil, -- Function to call after (un)comment
    }
  end
}

