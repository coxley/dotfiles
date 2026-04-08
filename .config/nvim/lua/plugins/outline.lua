return {
    {
        "hedyhli/outline.nvim",
        lazy = false,
        cmd = { "Outline", "OutlineOpen" },
        dependencies = {
            'onsails/lspkind.nvim',
        },
        keys = { -- Example mapping to toggle outline
            { "<leader><leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {
            symbols = {
                icon_source = 'lspkind',
            }
        },
    },
}
