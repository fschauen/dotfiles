local o = vim.opt

-- General
o.belloff     = 'all'           -- never ring bells
o.hidden      = true            -- hide abandoned buffers
o.clipboard   = 'unnamedplus'   -- synchronize with system clipboard
o.lazyredraw  = true            -- don't redraw screen during macros
o.modelines   = 0               -- never use modelines
o.fileformats = 'unix,mac,dos'  -- prioritize unix <EOL> format

o.swapfile    = false           -- don't use swap files
o.writebackup = true            -- Make a backup before writing a file...
o.backup      = false           -- ...but don't keep it around.

o.shortmess:append('I')         -- no intro message when starting Vim
o.shada = {
    "'1000",    -- remember marks for this many files
    "/1000",    -- remember this many search patterns
    ":1000",    -- remember this many command line items
    "<100",     -- maximum number of lines to remember per register
    "h",        -- disable 'hlsearch' while reading shada file
    "s100",     -- limit size of remembered items to this many KiB
}

-- Searching
o.ignorecase = true     -- Ignore case when searching...
o.smartcase = true      -- ...unless pattern contains uppercase characters.

-- Editing
o.expandtab     = true      -- use spaces whe <Tab> is inserted
o.tabstop       = 4         -- tabs are 4 spaces
o.shiftwidth    = 0         -- (auto)indent using 'tabstop' spaces
o.smartindent   = true      -- use smart autoindenting
o.inccommand    = 'split'   -- preview command partial results
o.joinspaces    = false     -- use one space after a period whe joining lines
o.showmatch     = true      -- briefly jump to matching bracket if insert one
o.virtualedit   = 'block'   -- position the cursor anywhere in Visual Block mode
o.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\|[-+*]\|[\[(][ x][\])]\)\s*]]
o.formatoptions = o.formatoptions
    - 't' -- Don't auto-wrap on 'textwidth'...
    + 'c' -- ...but do it within comment blocks...
    + 'l' -- ...but not if line was already long before entering Insert mode.
    + 'r' -- Insert comment leader when pressing Enter...
    - 'o' -- ...but not when opening a new line with o & O.
    + 'q' -- allow formatting of comments with gq
    - 'a' -- don't auto-format every time text is inserted
    + 'n' -- indent lists automatically acc. 'formatlistpat'
    + 'j' -- remove comment leader when joining lines
    + '1' -- don't break lines after a one letter word but rather before it

-- Appearance
o.showmode       = false    -- don't show mode (shown in statusline instead)
o.relativenumber = true     -- Start off with realtive line numbers...
o.number         = true     -- ...but real number for current line.
o.wrap           = false    -- don't wrap long lines initially
o.textwidth      = 79       -- maximum width for text being inserted
o.colorcolumn    = '+1'     -- highlight column after 'textwidth'
o.cursorline     = true     -- highlight the line of the cursor
o.showbreak      = '⤷ '     -- prefix for wrapped lines
o.scrolloff      = 3        -- min. # of lines above and below cursor
o.sidescrolloff  = 3        -- min. # of columns to left and right of cursor
o.list           = true     -- show invisible characters
o.listchars      = {
         tab = '» ',
     extends = '…',
    precedes = '…',
       trail = '·',
     conceal = '┊',
}

-- Wildcard Expansion
o.wildignore = {
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
}
o.wildignorecase = true             -- ignore case when completing file names
o.wildmode       = 'longest:full'   -- longest common prefix first, then wildmenu

-- Window Splitting
o.splitbelow  = true                -- :split below current window
o.splitright  = true                -- :vsplit to the right of current window
o.equalalways = false               -- don't resize all windows when splitting

-- Folding
o.foldenable     = true             -- enable folding
o.foldlevelstart = 100              -- start with all folds open
o.foldmethod     = 'syntax'         -- fold based on syntax by default
o.foldnestmax    = 10               -- limit nested folds to 10 levels

-- Options for diff mode
o.diffopt = {       -- better side-by-side diffs
    'filler',       -- show filler lines (so text ins vertically synced)
    'vertical',     -- use vertical splits (files side-by-side)
    'closeoff',     -- disable diff mode when one window is closed
}

