local M = {}

M.colors = function()
  local c = {
    base04  = '#002028',
    base03  = '#002b36',
    base02  = '#073642',
    base01  = '#586e75',
    base00  = '#657b83',
    base0   = '#839496',
    base1   = '#93a1a1',
    base2   = '#eee8d5',
    base3   = '#fdf6e3',
    base4   = '#ffffed',

    yellow  = '#b58900',
    orange  = '#cb4b16',
    red     = '#dc322f',
    magenta = '#d33682',
    violet  = '#6c71c4',
    blue    = '#268bd2',
    cyan    = '#2aa198',
    green   = '#719e07',  -- original: #859900
  }

  if vim.opt.background:get() == 'light' then
    c.base04, c.base4 = c.base4, c.base04
    c.base03, c.base3 = c.base3, c.base03
    c.base02, c.base2 = c.base2, c.base02
    c.base01, c.base1 = c.base1, c.base01
    c.base00, c.base0 = c.base0, c.base00
  end

  return c
end

M.highlights = function()
  local C = M.colors()
  local fg = C.base1
  local bg = 'none'  -- C.base04

  return {
    standard = {
      Normal         = { fg = fg, bg = bg },   -- normal text
      NormalNC       = { link = 'Normal' },    -- normal text in non-current windows

      Comment        = { fg = C.base01, italic = true },  -- any comment

      Constant       = { fg   = C.orange },  -- any constant
      String         = { fg   = C.cyan   },  -- a string constant: "this is a string"
      Character      = { link = 'String' },  -- a character constant: 'c', '\n'
      Number         = { link = 'String' },  -- a number constant: 234, 0xff
      Boolean        = { fg = C.cyan, bold = true, italic = true },  -- a boolean constant: TRUE, false
      Float          = { link = 'String' },  -- a floating point constant: 2.3e10

      Identifier     = { fg   = C.base1 },
      Function       = { fg   = C.blue },

      Statement      = { fg   = C.green    },   -- any statement
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

      Underlined     = { fg = C.violet, underline = true },
      Ignore         = { },
      Todo           = { fg = C.magenta, bold = true },
      Error          = { fg = C.red },
      Warning        = { fg = C.yellow},
      Information    = { fg = C.blue },
      Hint           = { fg = C.cyan },
    },

    additional = {
      StatusLine     = { fg = C.base1 , bg = C.base02, reverse = true},
      StatusLineNC   = { fg = C.base00, bg = C.base02, reverse = true},
      Visual         = { fg = C.base01, bg = bg,       reverse = true},

      SpecialKey     = { fg = C.base00, bg =C.base02, bold = true },
      SignColumn     = { fg = C.base0 },
      Conceal        = { fg = C.blue },
      Cursor         = { fg = bg, bg = C.base0 },
      TermCursorNC   = { fg = bg, bg = C.base01 },
      lCursor        = { link = 'Cursor' },
      TermCursor     = { link = 'Cursor' },

      LineNr         = { fg = C.base01 },
      CursorLine     = { bg = C.base03 },
      CursorLineNr   = { fg = C.base2 },

      IncSearch      = { fg = C.yellow, reverse = true },
      Search         = { fg = C.base2 , reverse = true },

      DiffAdd        = { fg = C.green },
      DiffChange     = { fg = C.yellow },
      DiffDelete     = { fg = C.red },
      DiffText       = { fg = C.blue },
      diffAdded      = { link = 'DiffAdd' },
      diffRemoved    = { link = 'DiffDelete' },
      diffLine       = { fg = C.violet },
      diffSubname    = { link = 'diffLine' },
      diffFile       = { fg = C.blue },
      diffIndexLine  = { link = 'diffFile' },

      SpellBad       = { fg = C.orange, undercurl = true },
      SpellCap       = { undercurl = true },
      SpellRare      = { undercurl = true },
      SpellLocal     = { undercurl = true },

      ErrorMsg       = { link = 'Error' },
      MoreMsg        = { fg = C.base2 },
      ModeMsg        = { fg = C.blue },
      Question       = { link = 'MoreMsg' },
      VertSplit      = { fg = C.base00 },
      Title          = { fg = C.yellow, bold = true },
      VisualNOS      = { bg = C.base02, reverse = true },
      WarningMsg     = { fg = C.orange },
      WildMenu       = { fg = C.base2, bg = C.base02 },
      Folded         = { fg = C.blue, bg = bg },
      FoldColumn     = { fg = C.blue, bg = bg },

      Directory      = { fg = C.blue },

      NonText        = { fg = C.base02 },                   -- subtle EOL symbols
      Whitespace     = { fg = C.orange },                   -- listchars
      QuickFixLine   = { fg = C.yellow , bg = C.base02 },   -- selected quickfix item

      TabLine     = { fg = C.base0 , bg = C.base02 },
      TabLineFill = { fg = C.base0 , bg = C.base02 },
      TabLineSel  = { fg = C.yellow, bg = bg },

      MatchParen  = { fg = C.red, bg = C.base01, bold = true },
    },

    pum = {
      Pmenu       = { fg = fg, bg = C.base02 },                      -- popup menu normal item
      PmenuSel    = { fg = C.base01, bg = C.base2, reverse = true},  -- selected item
      PmenuSbar   = { fg = C.base02, reverse = true },
      PmenuThumb  = { fg = C.base0, reverse = true },
    },

    vim = {
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
    },

    gitcommit = {
      gitcommitSummary         = { fg = C.green },
      gitcommitComment         = { link = 'Comment' },
      gitcommitUntracked       = { link = 'gitcommitComment' },
      gitcommitDiscarded       = { link = 'gitcommitComment' },
      gitcommitSelected        = { link = 'gitcommitComment' },
      gitcommitOnBranch        = { link = 'gitcommitComment' },

      gitcommitBranch          = { fg = C.blue, bg = C.base03 },
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
    },

    markdown = {
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
    },

    treesitter = {
      TSAnnotation          = { link = 'PreProc' },
      TSAttribute           = { link = 'PreProc' },
      TSBoolean             = { link = 'Boolean' },
      TSCharacter           = { link = 'Character' },
      TSCharacterSpecial    = { link = 'Special' },
      TSComment             = { link = 'Comment' },
      TSConditional         = { link = 'Conditional' },
      TSConstant            = { link = 'Constant' },
      TSConstBuiltin        = { link = 'Constant' },
      TSConstMacro          = { link = 'Define' },
      TSConstructor         = { fg = C.yellow },
      TSDebug               = { link = 'Debug' },
      TSDefine              = { link = 'Define' },
      TSError               = { link = 'Error' },
      TSException           = { link = 'Exception' },
      TSField               = { link = 'Identifier' },
      TSFloat               = { link = 'Float' },
      TSFunction            = { link = 'Function' },
      TSFunctionCall        = { link = 'Function' },
      TSFuncBuiltin         = { link = 'Function' },
      TSFuncMacro           = { link = 'Macro' },
      TSInclude             = { link = 'Include' },
      TSKeyword             = { link = 'Keyword' },
      TSKeywordFunction     = { link = 'Keyword' },
      TSKeywordOperator     = { link = 'Keyword' },
      TSKeywordReturn       = { link = 'Keyword' },
      TSLabel               = { link = 'Label' },
      TSMethod              = { link = 'TSFunction' },
      TSMethodCall          = { link = 'TSFunctionCall' },
      TSNamespace           = { link = 'Include' },
      TSNone                = { },
      TSNumber              = { link = 'Number' },
      TSOperator            = { fg = C.base2 },
      TSParameter           = { link = 'Identifier' },
      TSParameterReference  = { link = 'TSParameter' },
      TSPreProc             = { link = 'PreProc' },
      TSProperty            = { link = 'Identifier' },
      TSPunctDelimiter      = { fg = C.base01 },
      TSPunctBracket        = { link = 'Normal' },
      TSPunctSpecial        = { link = 'TSOperator' },
      TSRepeat              = { link = 'Repeat' },
      TSStorageClass        = { link = 'StorageClass' },
      TSString              = { link = 'String' },
      TSStringRegex         = { link = 'String' },
      TSStringEscape        = { link = 'SpecialChar' },
      TSStringSpecial       = { link = 'SpecialChar' },
      TSSymbol              = { link = 'Identifier' },
      TSTag                 = { link = 'Label' },
      TSTagAttribute        = { link = 'TSProperty' },
      TSTagDelimiter        = { link = 'Delimiter' },
      TSText                = { link = 'TSNone' },
      TSStrong              = { fg = C.base1, bold = true },
      TSEmphasis            = { fg = C.base1, italic = true },
      TSUnderline           = { underline = true },
      TSStrike              = { strikethrough = true },
      TSTitle               = { link = 'Title' },
      TSLiteral             = { link = 'markdownCode' },
      TSURI                 = { link = 'markdownUrl' },
      TSText                = { link = 'TSNone' },
      TSMath                = { link = 'Special' },
      TSTextReference       = { link = 'markdownLinkText' },
      TSEnvironment         = { link = 'Macro' },
      TSEnvironmentName     = { link = 'Constant' },
      TSNote                = { link = 'SpecialComment' },
      TSWarning             = { link = 'Todo' },
      TSDanger              = { link = 'WarningMsg' },
      TSTodo                = { link = 'Todo' },
      TSType                = { link = 'Type' },
      TSTypeBuiltin         = { link = 'Type' },
      TSTypeQualifier       = { },
      TSTypeDefinition      = { },
      TSVariable            = { link = 'Identifier' },
      TSVariableBuiltin     = { link = 'Identifier' },
    },

    -- 'tpope/vim-fugitive'
    fugitive = {
      fugitiveHeader              = { link = 'Label' },

      fugitiveHash                = { fg   = C.violet },
      fugitiveSymbolicRef         = { link = 'gitcommitBranch' },
      fugitiveCount               = { link = 'fugitiveUntrackedSection' },

      fugitiveHeading             = { fg   = C.yellow },
      fugitiveUntrackedHeading    = { link = 'gitcommitUntrackedFile' },
      fugitiveUnstagedHeading     = { link = 'gitcommitDiscardedFile' },
      fugitiveStagedHeading       = { link = 'gitcommitSelectedFile' },

      fugitiveSection             = { link = 'Normal' },
      fugitiveUntrackedSection    = { fg   = C.base2 },
      fugitiveUnstagedSection     = { link = 'fugitiveUntrackedSection' },
      fugitiveStagedSection       = { link = 'fugitiveUntrackedSection' },

      fugitiveModifier            = { link = 'fugitiveHeading' },
      fugitiveUntrackedModifier   = { link = 'gitcommitUntrackedFile' },
      fugitiveUnstagedModifier    = { link = 'gitcommitDiscardedFile' },
      fugitiveStagedModifier      = { link = 'gitcommitSelectedFile' },

      fugitiveHelpHeader          = { link = 'fugitiveHeader' },
      fugitiveHelpTag             = { link = 'Tag' },
      fugitiveInstruction         = { link = 'Type' },
      fugitiveStop                = { link = 'Function' },
    },

    -- 'ntpeters/vim-better-whitespace'
    better_whitespace = {
      ExtraWhitespace = { fg = C.orange, bg = C.orange }, -- trailing whitespace
    },

    -- 'lukas-reineke/indent-blankline.nvim'
    indent_blankline = {
      IndentBlanklineChar = { fg = C.base02 }, -- indentation guides
    },

    -- 'lukas-reineke/virt-column.nvim'
    virt_column = {
      VirtColumn  = { fg = C.base02 },  -- virtual column
      ColorColumn = {},  -- otherwise this is visible behind VirtColumn
    },

    -- 'kyazdani42/nvim-tree.lua'
    nvim_tree = {
      NvimTreeRootFolder   = { fg = C.blue, bold = true },
      NvimTreeFolderIcon   = { link = 'NvimTreeFolderName' },
      NvimTreeSpecialFile  = { fg = C.base2 },
      NvimTreeIndentMarker = { fg = C.base01 },
      NvimTreeGitStaged    = { fg = C.green },
      NvimTreeGitRenamed   = { fg = C.yellow },
      NvimTreeGitNew       = { fg = C.yellow },
      NvimTreeGitDirty     = { fg = C.yellow },
      NvimTreeGitDeleted   = { fg = C.orange },
      NvimTreeGitMerge     = { fg = C.red },
    },

    -- 'nvim-telescope/telescope.nvim'
    telescope = {
      TelescopeBorder         = { fg = C.base0 },
      TelescopePromptBorder   = { fg = C.base3 },
      TelescopeTitle          = { fg = C.blue },
      TelescopePromptPrefix   = { fg = C.blue },
      TelescopePromptCounter  = { fg = C.base00 },
      TelescopeMatching       = { fg = C.red },
      TelescopeSelection      = { fg = C.base2, bg = C.base03 },
      TelescopeMultiSelection = { fg = C.green },
      TelescopeMultiIcon      = { fg = C.green },
    },
  }
end

M.setup = function()
  vim.cmd 'hi clear'
  if vim.fn.exists('syntax_on') then
    vim.cmd 'syntax reset'
  end
  vim.g.colors_name = 'solarized'

  local nvim_set_hl = vim.api.nvim_set_hl
  for _, section in pairs(M.highlights()) do
    for group_name, attributes in pairs(section) do
      nvim_set_hl(0, group_name, attributes)
    end
  end
end

return M

