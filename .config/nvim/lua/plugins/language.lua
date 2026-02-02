local disable_formatexpr = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
    vim.api.nvim_buf_set_option(bufnr, "formatprg", "")
end

return {
    {
        'crusj/hierarchy-tree-go.nvim',
        config = function()
            require("hierarchy-tree-go").setup({
                icon = {
                    fold = "", -- fold icon
                    unfold = "", -- unfold icon
                    func = "₣", -- symbol
                    last = '☉', -- last level icon
                },
                hl = {
                    current_module = "guifg=Green",       -- highlight cwd module line
                    others_module = "guifg=Black",        -- highlight others module line
                    cursorline = "guibg=Gray guifg=White" -- hl  window cursorline
                },
                keymap = {
                    --global keymap
                    incoming = "<leader>fi", -- call incoming under cursorword
                    outgoing = "<leader>fo", -- call outgoing under cursorword
                    open = "<leader>ho",     -- open hierarchy win
                    close = "<leader>hc",    -- close hierarchy win
                    -- focus: if hierarchy win is valid but is not current win, set to current win
                    -- focus: if hierarchy win is valid and is current win, close
                    -- focus  if hierarchy win not existing,open and focus
                    focus = "<leader>fu",

                    -- bufkeymap
                    expand = "o",           -- expand or collapse hierarchy
                    jump = "<CR>",          -- jump
                    move = "<space><space>" -- switch the hierarchy window position, must be current win
                }
            })
        end
    },
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
        ft = { "go" },
        config = function()
            require('go').setup({
                lsp_config = false,
                lsp_document_formatting = false,
                null_ls = nil,
                luasnip = true,
            })
            local gopls_cfg = require('go.lsp').config()
            gopls_cfg.on_attach = disable_formatexpr
            gopls_cfg.filetypes = { "go", "gomod" }

            if vim.env.DATADOG_ROOT ~= nil then
                gopls_cfg.cmd = { 'dd-gopls' }
                gopls_cfg.cmd_env = {
                    GOPLS_DISABLE_MODULE_LOADS = 1,
                }
            end
            gopls_cfg.settings = {
                gopls = {
                    remote = "auto",
                    matcher = 'CaseInsensitive',
                    ['local'] = 'github.com/DataDog',
                    gofumpt = true,
                    semanticTokens = true,
                    semanticTokenModifiers = {
                        string = false,
                    },
                    codelenses = {
                        gc_details = true,
                    },
                    hints = {
                        constant_values = false,
                        constantValues = false,
                    },
                    analyses = {
                        unusedparams = false,
                        -- fieldalignment = true,
                        nilness = true,
                        unusedwrite = true,
                        useany = true,
                        stdversion = true,
                    },
                    staticcheck = true,
                    -- usePlaceholders = true,
                    experimentalPostfixCompletions = true,
                },
            }
            vim.lsp.config.gopls = gopls_cfg
            vim.lsp.enable('gopls')
            -- vim.api.nvim_create_autocmd('BufWritePre', {
            --     pattern = '*.go',
            --     callback = function()
            --         vim.lsp.buf.code_action({
            --             context = {
            --                 only = { 'source.organizeImports' },
            --             },
            --             apply = true,
            --         })
            --     end
            -- })

            local map = vim.api.nvim_set_keymap
            local options = { noremap = true, silent = true }
            map('n', '<leader>gfs', ':GoFillStruct<CR>', options)

            -- Organize imports on save for Go
            vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
        end
    },
}
