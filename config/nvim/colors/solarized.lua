local C = require('fs.util').colors()
local fg = C.base0
local bg = C.base04

local theme = {
  -- Standard Groups
  Normal         = { fg = fg, bg = bg },   -- normal text
  NormalNC       = { link = 'Normal' },    -- normal text in non-current windows

  Comment        = { fg = C.base01 },      -- any comment

  Constant       = { fg   = C.cyan },      -- any constant
  String         = { link = 'Constant' },  -- a string constant: "this is a string"
  Character      = { link = 'Constant' },  -- a character constant: 'c', '\n'
  Number         = { link = 'Constant' },  -- a number constant: 234, 0xff
  Boolean        = { link = 'Constant' },  -- a boolean constant: TRUE, false
  Float          = { link = 'Constant' },  -- a floating point constant: 2.3e10

  Identifier     = { fg   = C.blue },
  Function       = { link = 'Identifier' },

  Statement      = { fg   = C.yellow },     -- any statement
  Conditional    = { link = 'Statement' },  -- if, then, else, endif, switch, etc.
  Repeat         = { link = 'Statement' },  -- for, do, while, etc.
  Label          = { link = 'Statement' },  -- case, default, etc.
  Operator       = { link = 'Statement' },  -- "sizeof", "+", "*", etc.
  Keyword        = { link = 'Statement' },  -- any other keyword
  Exception      = { link = 'Statement' },  -- try, catch, throw

  PreProc        = { fg   = C.orange },     -- generic Preprocessor
  Include        = { link = 'PreProc' },    -- preprocessor #include
  Define         = { link = 'PreProc' },    -- preprocessor #define
  Macro          = { link = 'PreProc' },    -- same as Define
  PreCondit      = { link = 'PreProc' },    -- preprocessor #if, #else, #endif, etc.

  Type           = { fg   = C.yellow },     -- int, long, char, etc.
  StorageClass   = { link = 'Statement' },  -- static, register, volatile, etc.
  Structure      = { link = 'Statement' },  -- struct, union, enum, etc.
  Typedef        = { link = 'Statement' },  -- A typedef

  Special        = { fg   = C.red },        -- any special symbol
  SpecialChar    = { link = 'Special' },    -- special character in a constant
  Tag            = { link = 'Special' },    -- you can use CTRL-] on this
  Delimiter      = { link = 'Special' },    -- character that needs attention
  SpecialComment = { link = 'Special' },    -- special things inside a comment
  Debug          = { link = 'Special' },    -- debugging statements

  Underlined     = { fg = C.violet },
  Ignore         = {},
  Todo           = { fg = C.magenta, bold = true },
  Error          = { fg = C.red },
  Warning        = { fg = C.yellow},
  Information    = { fg = C.blue },
  Hint           = { fg = C.cyan },

  -- Additional Groups
  StatusLine   = { fg = C.base1 , bg = C.base02, reverse = true},
  StatusLineNC = { fg = C.base00, bg = C.base02, reverse = true},
  Visual       = { fg = C.base01, bg = bg,       reverse = true},

  SpecialKey   = { fg = C.base00, bg =C.base02, bold = true },
  SignColumn   = { fg = C.base0 },
  Conceal      = { fg = C.blue },
  Cursor       = { fg = bg, bg = C.base0 },
  TermCursorNC = { fg = bg, bg = C.base01 },
  lCursor      = { link = 'Cursor' },
  TermCursor   = { link = 'Cursor' },

  LineNr       = { fg = C.base01 },
  CursorLine   = { bg = C.base02 },
  CursorLineNr = { fg = C.base2 },

  IncSearch    = { fg = C.orange , standout = true },
  Search       = { fg = C.yellow , reverse = true },

  DiffAdd      = { fg = C.green },
  DiffChange   = { fg = C.yellow },
  DiffDelete   = { fg = C.red },
  DiffText     = { fg = C.blue },
  diffAdded    = { link = 'DiffAdd' },
  diffRemoved  = { link = 'DiffDelete' },
  diffLine     = { link = 'Identifier' },

  SpellBad     = { fg = C.orange, undercurl = true },
  SpellCap     = { fg = C.violet, undercurl = true },
  SpellRare    = { fg = C.cyan  , undercurl = true },
  SpellLocal   = { fg = C.yellow, undercurl = true },

  ErrorMsg     = { link = 'Error' },
  MoreMsg      = { fg = C.blue },
  ModeMsg      = { fg = C.blue },
  Question     = { fg = C.cyan, bold = true },
  VertSplit    = { fg = C.base00 },
  Title        = { fg = C.orange, bold = true },
  VisualNOS    = { bg = C.base02, reverse = true },
  WarningMsg   = { fg = C.red },
  WildMenu     = { fg = C.base2, bg = C.base02 },
  Folded       = { fg = C.blue, bg = bg },
  FoldColumn   = { fg = C.blue, bg = bg },

  Directory    = { fg = C.blue },

  NonText      = { fg = C.base02 },                   -- subtle EOL symbols
  Whitespace   = { fg = C.orange },                   -- listchars
  QuickFixLine = { fg = C.yellow , bg = C.base02 },   -- selected quickfix item

  -- pum (popup menu)
  Pmenu       = { fg = fg, bg = C.base02 },                      -- popup menu normal item
  PmenuSel    = { fg = C.base01, bg = C.base2, reverse = true},  -- selected item
  PmenuSbar   = { fg = C.base02, reverse = true },
  PmenuThumb  = { fg = C.base0, reverse = true },

  TabLine     = { fg = C.base0 , bg = C.base02 },
  TabLineFill = { fg = C.base0 , bg = C.base02 },
  TabLineSel  = { fg = C.yellow, bg = bg },

  MatchParen  = { fg = C.red, bg = C.base01, bold = true },

  -- vim highlighting
  vimVar             = { link = 'Identifier' },
  vimFunc            = { link = 'Identifier' },
  vimUserFunc        = { link = 'Identifier' },
  helpSpecial        = { link = 'Special' },
  vimSet             = { link = 'Normal' },
  vimSetEqual        = { link = 'Normal' },
  vimCommentString   = { fg = C.violet },
  vimCommand         = { fg = C.yellow },
  vimCmdSep          = { fg = C.blue, bold = true },
  helpExample        = { fg = C.base1 },
  helpOption         = { fg = C.cyan },
  helpNote           = { fg = C.magenta },
  helpVim            = { fg = C.magenta },
  helpHyperTextJump  = { fg = C.blue, underline = true },
  helpHyperTextEntry = { fg = C.green },
  vimIsCommand       = { fg = C.base00 },
  vimSynMtchOpt      = { fg = C.yellow },
  vimSynType         = { fg = C.cyan },
  vimHiLink          = { fg = C.blue },
  vimGroup           = { fg = C.blue, underline = true, bold = true},

  -- git highlighting
  gitcommitSummary         = { fg = C.green },
  gitcommitComment         = { link = 'Comment' },
  gitcommitUntracked       = { link = 'gitcommitComment' },
  gitcommitDiscarded       = { link = 'gitcommitComment' },
  gitcommitSelected        = { link = 'gitcommitComment' },
  gitcommitOnBranch        = { link = 'gitcommitComment' },

  gitcommitBranch          = { fg = C.blue, bg = C.base02 },
  gitcommitNoBranch        = { link = 'gitcommitBranch' },

  gitcommitHeader          = { fg = C.base01 },
  gitcommitFile            = { fg = C.base0 },

  gitcommitSelectedType    = { fg = C.green },
  gitcommitSelectedFile    = { link = 'gitcommitSelectedType' },
  gitcommitSelectedArrow   = { link = 'gitCommitSelectedFile' },

  gitcommitDiscardedType   = { fg = C.orange },
  gitcommitDiscardedFile   = { link = 'gitcommitDiscardedType' },
  gitcommitDiscardedArrow  = { link = 'gitCommitDiscardedFile' },

  gitcommitUntrackedFile   = { fg = C.cyan },

  gitcommitUnmerged        = { fg = C.yellow },
  gitcommitUnmergedFile    = { fg = C.red },
  gitcommitUnmergedArrow   = { link = 'gitCommitUnmergedFile' },

  GitGutterAdd             = { fg = C.green },
  GitGutterChange          = { fg = C.yellow },
  GitGutterDelete          = { fg = C.red },
  GitGutterChangeDelete    = { fg = C.red },

  GitSignsAddLn            = { fg = C.green },
  GitSignsAddNr            = { fg = C.green },
  GitSignsChangeLn         = { fg = C.yellow },
  GitSignsChangeNr         = { fg = C.yellow },
  GitSignsDeleteLn         = { fg = C.red },
  GitSignsDeleteNr         = { fg = C.red },
  GitSignsCurrentLineBlame = { link = 'Comment' },

  -- Markdown
  markdownH1                  = { fg = C.yellow },
  markdownH2                  = { link = 'markdownH1' },
  markdownH3                  = { link = 'markdownH1' },
  markdownH4                  = { link = 'markdownH1' },
  markdownH5                  = { link = 'markdownH1' },
  markdownH6                  = { link = 'markdownH1' },
  markdownHeadingRule         = { fg = C.yellow, bold = true },
  markdownHeadingDelimiter    = { link = 'markdownHeadingRule' },
  markdownH1Delimiter         = { link = 'markdownHeadingDelimiter' },
  markdownH2Delimiter         = { link = 'markdownHeadingDelimiter' },
  markdownH3Delimiter         = { link = 'markdownHeadingDelimiter' },
  markdownH4Delimiter         = { link = 'markdownHeadingDelimiter' },
  markdownH5Delimiter         = { link = 'markdownHeadingDelimiter' },
  markdownH6Delimiter         = { link = 'markdownHeadingDelimiter' },

  markdownListMarker          = { fg = C.base2 },
  markdownOrderedListMarker   = { link = 'markdownListMarker' },
  markdownBlockquote          = { fg = C.base2, bold = true, italic = true },
  markdownRule                = { link = 'Comment' },

  markdownItalic              = { fg = C.base1, italic = true },
  markdownBold                = { fg = C.base1, bold = true },
  markdownBoldItalic          = { fg = C.base1, bold = true, italic = true },
  markdownCode                = { fg = C.orange },
  markdownCodeBlock           = { link = 'markdownCode' },
  markdownItalicDelimiter     = { link = 'Comment' },
  markdownBoldDelimiter       = { link = 'Comment' },
  markdownBoldItalicDelimiter = { link = 'Comment' },
  markdownCodeDelimiter       = { link = 'Comment' },

  markdownFootnote            = { fg = C.cyan },
  markdownFootnoteDefinition  = { link = 'markdownFootnote' },

  markdownLinkText            = { fg = C.blue },
  markdownId                  = { link = 'Comment' },
  markdownUrl                 = { link = 'Comment' },
  markdownUrlTitle            = { fg = C.cyan },

  markdownLinkTextDelimiter   = { link = 'Comment' },
  markdownIdDelimiter         = { link = 'Comment' },
  markdownLinkDelimiter       = { link = 'Comment' },
  markdownUrlTitleDelimiter   = { link = 'Comment' },
  markdownIdDeclaration       = { link = 'markdownLinkText' },

  markdownEscape              = { link = 'Special' },
  markdownError               = { link = 'Error' },

  -- Plugin: 'ntpeters/vim-better-whitespace'
  ExtraWhitespace = { fg = C.orange, bg = C.orange }, -- trailing whitespace

  -- Plugin: 'lukas-reineke/indent-blankline.nvim'
  IndentBlanklineChar = { fg = C.base02 }, -- indentation guides

  -- Plugin: 'lukas-reineke/virt-column.nvim'
  VirtColumn  = { fg = C.base02 },  -- virtual column
  ColorColumn = {},  -- otherwise this is visible behind VirtColumn

  -- Plugin: 'kyazdani42/nvim-tree.lua'
  NvimTreeSpecialFile  = { fg = C.base2 },
  NvimTreeIndentMarker = { fg = C.base01 },
  NvimTreeGitStaged    = { fg = C.green },
  NvimTreeGitRenamed   = { fg = C.yellow },
  NvimTreeGitNew       = { fg = C.yellow },
  NvimTreeGitDirty     = { fg = C.yellow },
  NvimTreeGitDeleted   = { fg = C.orange },
  NvimTreeGitMerge     = { fg = C.red },

  -- Plugin: 'nvim-telescope/telescope.nvim'
  TelescopeBorder         = { fg = C.base01 },
  TelescopePromptBorder   = { fg = C.base1 },
  TelescopeTitle          = { fg = C.base1 },
  TelescopePromptPrefix   = { fg = C.red },
  TelescopePromptCounter  = { fg = C.base1 },
  TelescopeMatching       = { fg = C.red },
  TelescopeSelection      = { fg = C.base2 },
  TelescopeMultiSelection = { fg = C.blue },
  TelescopeMultiIcon      = { fg = C.blue },
}

local apply_higlights = function(highlights)
  vim.cmd 'hi clear'
  if vim.fn.exists('syntax_on') then
    vim.cmd 'syntax reset'
  end
  vim.g.colors_name = 'solarized'

  local nvim_set_hl = vim.api.nvim_set_hl
  for name, definition in pairs(highlights) do
    nvim_set_hl(0, name, definition)
  end
end

apply_higlights(theme)

