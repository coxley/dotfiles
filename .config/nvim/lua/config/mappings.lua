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

vim.api.nvim_create_user_command("LinkToCode", function(opts)
    local open = false
    local blame = false
    for _, arg in ipairs(opts.fargs) do
        if arg == "open" then
            open = true
        end
        if arg == "blame" then
            blame = true
        end
    end
    require("link2code").run {
        blame = blame,
        open = open,
        line1 = opts.line1,
        line2 = opts.line2,
    }
end, {
    range = true,
    nargs = "*",
})

vim.keymap.set({ "n", "v" }, "<leader><leader>l", ":LinkToCode<CR>", options)
vim.keymap.set({ "n", "v" }, "<leader><leader>b", ":LinkToCode blame<CR>", options)
vim.keymap.set({ "n", "v" }, "<leader>ol", ":LinkToCode open<CR>", options)
vim.keymap.set({ "n", "v" }, "<leader>ob", ":LinkToCode open blame<CR>", options)

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection DOWN" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection UP" })

map('n', '<C-n>', ':cnext<CR>', options)
map('n', '<C-p>', ':cprevious<CR>', options)
