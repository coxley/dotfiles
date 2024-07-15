return {
    {
        "earthly/earthly.vim",
        branch = "main",
        commit = "8f6beb9158cfb40b2a3d9b8c28da708e1b23d7a3",
    },
    "mattn/vim-goaddtags",
    "ekalinin/Dockerfile.vim",
    {
        "sheerun/vim-polyglot",
        cond = false,
        init = function()
            vim.cmd("let g:polyglot_disabled = ['ftdetect']")
        end,
    },
    {
        "ray-x/go.nvim",
        ft = {"go"},
        config = function()
            require('go').setup({})
            require("lspconfig").gopls.setup({
                filetypes = { "go", "gomod" },
                -- root_dir = util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        matcher = 'CaseInsensitive',
                        ['local'] = 'github.com/TriggerMail',
                        gofumpt = true,
                        codelenses = {
                            gc_details = true,
                        },
                        annotations = {
                            escape = true,
                        },
                        analyses = {
                            unusedparams = false,
                            fieldalignment = true,
                            nilness = true,
                            unusedwrite = true,
                            useany = true,
                            stdversion = true,
                        },
                        staticcheck = true,
                    },
                },
            })
            vim.api.nvim_create_autocmd('BufWritePre', {
                pattern = '*.go',
                callback = function()
                    vim.lsp.buf.code_action({
                        context = {
                            only = { 'source.organizeImports' },
                        },
                        apply = true,
                    })
                end
            })

            local map = vim.api.nvim_set_keymap
            local options = { noremap = true, silent = true }
            map('n', '<leader>gfs', ':GoFillStruct<CR>', options)

            -- Organize imports on save for Go
            vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
        end
    },
}
