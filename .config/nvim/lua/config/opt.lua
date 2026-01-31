-- Merge vim clipboard with macOS
vim.opt.clipboard = 'unnamed'

vim.g.loaded_python_provider = 0

-- Display certain whitespace characters differently
vim.opt.list = true
vim.opt.listchars = {
    nbsp = '⦸',
    tab = '▸ ',
    extends = '»',
    precedes = '«'
}

-- Mode is already shown in the status line
vim.api.nvim_command('set noshowmode')

-- Put backup + undo shit into XDG share and cache
--
-- Persists undo-history per-file "forever", across sessions.
vim.api.nvim_set_var("swapdir", vim.fn.stdpath('cache') .. '/swap')
vim.api.nvim_set_var("backupdir", vim.fn.stdpath('cache') .. '/backup')
vim.api.nvim_set_var("undodir", vim.fn.stdpath('cache') .. '/undo')
vim.opt.writebackup = true
vim.opt.undofile = true


-- More intiutive split destinations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- While rare, allow clicking anywhere to jump the cursor
vim.opt.mouse = 'a'

-- Control behavior of the completion options displayed
vim.opt.wildmenu = true
vim.opt.wildmode = { list = 'longest:full', 'full' }
vim.opt.wildignore = { '*.swp', '*.bak', '*.pyc', '*.class' }

-- Ignore case when searching unless there's an uppercase character
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.title = true
vim.opt.visualbell = true

-- Controls message formats and abbreviations
vim.opt.shortmess = 'AIOTWaot'

-- Use Treesitter for indentation logic
vim.opt.indentexpr = "nvim_treesitter#indent()"

-- 4-space tabs, resolved to spaces. To be overridden by formatting / LSP where
-- relevant.
--
-- Also round to the closest tabstop when shifting blocks of text
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftround = true

vim.api.nvim_command [[autocmd VimResized * exe "normal \<c-w>="]]
vim.api.nvim_command [[match SpellRare /\d\{1,3}\ze\%(\d\{6}\)*\d\{3}\>/]]
