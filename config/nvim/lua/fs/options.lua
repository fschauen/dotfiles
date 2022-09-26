vim.cmd [[let &t_8f = "\<ESC>[38:2:%lu:%lu:%lum"]]
vim.cmd [[let &t_8b = "\<ESC>[48:2:%lu:%lu:%lum"]]

local set_options = function(options)
  local opt = vim.opt
  for k, v in pairs(options) do
    opt[k] = v
  end
end

set_options {
  -- General
  belloff     = 'all',          -- never ring bells
  hidden      = true,           -- hide abandoned buffers
  clipboard   = 'unnamedplus',  -- synchronize with system clipboard
  lazyredraw  = true,           -- don't redraw screen during macros
  modelines   = 0,              -- never use modelines
  fileformats = 'unix,mac,dos', -- prioritize unix <EOL> format
  pastetoggle = '<F20>',        -- toggle paste with P on Moonlander

  swapfile    = false,          -- don't use swap files
  writebackup = true,           -- Make a backup before writing a file...
  backup      = false,          -- ...but don't keep it around.

  shortmess   = vim.opt.shortmess + 'I',  -- no intro message when starting Vim
  shada = {
    "'1000",    -- remember marks for this many files
    "/1000",    -- remember this many search patterns
    ":1000",    -- remember this many command line items
    "<100",     -- maximum number of lines to remember per register
    "h",        -- disable 'hlsearch' while reading shada file
    "s100",     -- limit size of remembered items to this many KiB
  },

  -- Searching
  ignorecase = true,    -- Ignore case when searching...
  smartcase = true,     -- ...unless pattern contains uppercase characters.

  -- Editing
  expandtab     = true,     -- use spaces whe <Tab> is inserted
  tabstop       = 4,        -- tabs are 4 spaces
  shiftwidth    = 0,        -- (auto)indent using 'tabstop' spaces
  smartindent   = true,     -- use smart autoindenting
  inccommand    = 'split',  -- preview command partial results
  joinspaces    = false,    -- use one space after a period whe joining lines
  showmatch     = true,     -- briefly jump to matching bracket if insert one
  virtualedit   = 'block',  -- position the cursor anywhere in Visual Block mode
  formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\|[-+*]\|[\[(][ x][\])]\)\s*]],
  formatoptions = vim.opt.formatoptions
      - 't'   -- Don't auto-wrap on 'textwidth'...
      + 'c'   -- ...but do it within comment blocks...
      + 'l'   -- ...but not if line was already long before entering Insert mode.
      + 'r'   -- Insert comment leader when pressing Enter...
      - 'o'   -- ...but not when opening a new line with o & O.
      + 'q'   -- allow formatting of comments with gq
      - 'a'   -- don't auto-format every time text is inserted
      + 'n'   -- indent lists automatically acc. 'formatlistpat'
      + 'j'   -- remove comment leader when joining lines
      + '1',  -- don't break lines after a one letter word but rather before it

  -- Appearance
  termguicolors  = true,    -- use "gui" :higlight instead of "cterm"
  showmode       = false,   -- don't show mode (shown in statusline instead)
  relativenumber = true,    -- Start off with realtive line numbers...
  number         = true,    -- ...but real number for current line.
  wrap           = false,   -- don't wrap long lines initially
  textwidth      = 79,      -- maximum width for text being inserted
  colorcolumn    = '+1',    -- highlight column after 'textwidth'
  cursorline     = true,    -- highlight the line of the cursor
  showbreak      = '⤷ ',    -- prefix for wrapped lines
  scrolloff      = 3,       -- min. # of lines above and below cursor
  sidescrolloff  = 3,       -- min. # of columns to left and right of cursor
  list           = true,    -- show invisible characters
  listchars      = {
    eol = '↲',
    tab = '» ',
    extends = '…',
    precedes = '…',
    trail = '·',
    conceal = '┊',
  },

  -- Wildcard Expansion
  wildignore = {
    '.git',
    '.svn',
    '__pycache__',
    '**/tmp/**',
    '*.DS_Store',
    '*.dll',
    '*.egg-info',
    '*.exe',
    '*.gif',
    '*.jpeg',
    '*.jpg',
    '*.o',
    '*.obj',
    '*.out',
    '*.png',
    '*.pyc',
    '*.so',
    '*.zip',
    '*~',
  },
  wildignorecase = true,            -- ignore case when completing file names
  wildmode       = 'longest:full',  -- longest common prefix first, then wildmenu

  -- Window Splitting
  splitbelow  = true,               -- :split below current window
  splitright  = true,               -- :vsplit to the right of current window
  equalalways = false,              -- don't resize all windows when splitting

  -- Folding
  foldenable     = true,            -- enable folding
  foldlevelstart = 100,             -- start with all folds open
  foldmethod     = 'syntax',        -- fold based on syntax by default
  foldnestmax    = 10,              -- limit nested folds to 10 levels

  -- Options for diff mode
  diffopt = {       -- better side-by-side diffs
    'filler',       -- show filler lines (so text ins vertically synced)
    'vertical',     -- use vertical splits (files side-by-side)
    'closeoff',     -- disable diff mode when one window is closed
  },
}

