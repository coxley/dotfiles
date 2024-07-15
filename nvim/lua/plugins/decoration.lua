return {
    "HiPhish/rainbow-delimiters.nvim",
    {
        "nanozuki/tabby.nvim",
        config = function()
            vim.o.showtabline = 2
            require('tabby.tabline').use_preset('active_wins_at_tail', {
                theme = {
                    fill = 'TabLineFill',       -- tabline background
                    head = 'TabLine',           -- head element highlight
                    current_tab = 'TabLineSel', -- current tab label highlight
                    tab = 'TabLine',            -- other tab label highlight
                    win = 'TabLine',            -- window highlight
                    tail = 'TabLine',           -- tail element highlight
                },
                buf_name = {
                    -- 'unique'|'relative'|'tail'|'shorten'
                    mode = 'shorten',
                },
            })
        end
    },
    "nvim-tree/nvim-web-devicons",
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = 'catppuccin-macchiato',
                -- theme = 'kanagawa',
            }
        },
    },
}
