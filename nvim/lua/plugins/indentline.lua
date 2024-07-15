return {
    {
        "nvimdev/indentmini.nvim",
        cond = false,
        config = function()
            require("indentmini").setup({
                exclude = { 'markdown' },
                char = '│',
                minlevel = 2,
            })
            vim.cmd.highlight('IndentLine guifg=#363a4f')
            vim.cmd.highlight('IndentLineCurrent guifg=#6e738d')
        end,
    },
}
