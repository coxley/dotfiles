return {
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/Documents/Org/**/*',
                org_default_notes_file = '~/Documents/Org/refile.org',
            })
            -- Experimental LSP support
            vim.lsp.enable('org')

            require('org-bullets').setup()
            require("headlines").setup()

            local Menu = require("org-modern.menu")
            require("orgmode").setup({
                ui = {
                    menu = {
                        handler = function(data)
                            local lines = 0
                            local longest_line = 0
                            for _, line in pairs(data.items) do
                                if line.label ~= nil then
                                    lines = lines + 1
                                    longest_line = math.max(longest_line, string.len(line.label))
                                end
                            end

                            local padding = 1
                            local v_margin = math.floor((vim.o.lines - #data.items - padding) / 2)
                            local h_margin = math.floor((vim.o.columns - longest_line - padding) / 2)
                            Menu:new({
                                window = {
                                    margin = { 0, h_margin / 2, v_margin, h_margin / 2 },
                                    padding = { padding, padding, padding, padding },
                                    title_pos = "center",
                                    border = "single",
                                    zindex = 1000,
                                },
                                icons = {
                                    separator = "➜",
                                },
                            }):open(data)
                        end,
                    },
                },
            })
        end,
    },
    {
        'nvim-orgmode/org-bullets.nvim',
        event = 'VeryLazy',
    },
    {
        "lukas-reineke/headlines.nvim",
        event = 'VeryLazy',
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            markdown = {
                headline_highlights = false
            }
        }
    },
    {
        "danilshvalov/org-modern.nvim",
        event = 'VeryLazy',
    },
}
