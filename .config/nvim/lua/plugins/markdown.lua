return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-mini/mini.nvim',
        },
        config = function()
            require('render-markdown').setup({
                file_types = { 'markdown', 'vimwiki' },
                render_modes = true,
                on = {
                    -- Reset highlighting because reset_highlight_markdown doesn't work
                    -- for me
                    initial = function()
                        local timer = vim.loop.new_timer()
                        timer:start(0, 0, vim.schedule_wrap(function()
                            vim.cmd.TSBufToggle('highlight')
                            vim.cmd.TSBufToggle('highlight')
                        end))
                    end,
                },
                bullet = {
                    icons = {
                        '‣',
                        '▪',
                        '▷',
                    },
                },
                -- link = {
                --     footnote = {
                --         icon = '',
                --     },
                --     highlight = '@markup.link.url',
                -- },
            })
        end,
    },
}
