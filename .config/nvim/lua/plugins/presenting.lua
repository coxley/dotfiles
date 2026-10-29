return {
    {
        'sotte/presenting.nvim',
        opts = {
            options = {
                width = 120,
            },
        },
        cmd = { "Presenting" },
        init = function()
            local active = false
            vim.api.nvim_create_user_command("Slides", function()
                if not active then
                    vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
                    vim.api.nvim_set_hl(0, "Cursor", { bg = "bg", fg = "fg", reverse = false })
                    vim.opt.ruler = false
                    vim.opt.laststatus = 0
                    vim.cmd('ScrollbarHide')
                    active = true
                else
                    vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
                    vim.api.nvim_set_hl(0, "Cursor", { bg = "bg", fg = "fg", reverse = true })
                    vim.opt.ruler = true
                    vim.opt.laststatus = 2
                    vim.cmd('ScrollbarShow')
                    active = false
                end
                vim.cmd('Presenting')
            end, {})
        end,
    },
}
