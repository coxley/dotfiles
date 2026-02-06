local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.g.mapleader = ','

map('i', 'hh', '<Esc>', options)
map('n', '<leader><leader>n', ':nohl<CR>', options)
map('n', 'Q', ':q<CR>', options)
-- map('n', 'bq', ':BufferClose<CR>', options)
map('n', '<C-s>', ':w<CR>', options)
map('n', '<C-s>', ':w<CR>', options)

-- Expand all buffers into tabs
map('n', '<leader>ba', ':ball<CR>', options)

-- Top/bottom helpers
map('n', '<CR>', 'G', options)
map('n', '<BS>', 'gg', options)

-- Split navigation
map('n', 'vv', ':vnew<CR>', options)
map('n', 'VV', ':vsplit<CR>', options)
map('n', '--', '<C-w>n', options)
map('n', '__', ':split<CR>', options)
map('n', '<C-J>', '<C-W><C-J>', options)
map('n', '<C-K>', '<C-W><C-K>', options)
map('n', '<C-L>', '<C-W><C-L>', options)
map('n', '<C-H>', '<C-W><C-H>', options)

map('v', 'Y', "y']", options)

map('n', 'mt', 'call MoveToNextTab()<CR>', options)
map('n', 'mT', 'call MoveToPrevTab()<CR>', options)

map('n', '<space>', 'za', options)
map('v', '<space>', 'zf', options)

map('n', '<leader>ge', ':GoIfErr<CR>', options)
map('n', '<leader>gr', ':GoGenReturn<CR>', options)

vim.api.nvim_command([[
function! LinkToCode(blame = 0) range
    let lineRange = printf("%d", line('.'))
    " If visual selection exists
    if a:lastline - a:firstline > 0
        let lineRange = printf("%d-%d", a:firstline, a:lastline)
    endif

    let filePath = expand("%:p")
    let filePos = printf("%s:%s", filePath, lineRange)

    let cmd = printf("link2code %s 2> /dev/null", filePos)
    if a:blame
        let cmd = printf("link2code --blame %s 2> /dev/null", filePos)
    endif
    let link = system(cmd)[:-2]  " ^@ is printed at the end of system()
    let @+ = link
    redraw
    echom printf("Copied to clipboard: %s", link)
endfunction

nnoremap <leader><leader>l :call LinkToCode()<CR>
vnoremap <leader><leader>l :call LinkToCode()<CR>
nnoremap <leader><leader>b :call LinkToCode(v:true)<CR>
vnoremap <leader><leader>b :call LinkToCode(v:true)<CR>
]])

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection DOWN" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection UP" })

map('n', '<C-n>', ':cnext<CR>', options)
map('n', '<C-p>', ':cprevious<CR>', options)
