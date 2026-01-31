return {
    {
        "lukas-reineke/virt-column.nvim",
        config = function()
            vim.opt.ruler = true
            vim.opt.textwidth = 87
            vim.opt.cursorline = true

            vim.opt.formatoptions = 'croq1j'

            -- TODO: Override 'wrap' on markdown files
            vim.opt.wrap = false

            -- Always display concrete line numbers and scroll the page 5 lines ahead/behind the
            -- cursor
            vim.opt.number = true
            vim.opt.relativenumber = false -- fuck bpremo
            vim.opt.scrolloff = 5

            vim.api.nvim_command('highlight virtcolumn ctermfg=235 guifg=#44475a')
            require('virt-column').setup({
                enabled = true,
                char = '│',
                virtcolumn = '+2',
                highlight = 'virtcolumn',
            })
        end,
    },
}
