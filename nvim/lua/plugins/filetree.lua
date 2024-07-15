return {
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { '<leader><leader>t', ':NvimTreeToggle<CR>', desc = "Toggle Filetree" },
        },
        priority = 1000,
        init = function()
            vim.g.loaded = 1
            vim.g.loaded_netrwPlugin = 1
            vim.g.lua_tree_tab_open = 0
        end,
        opts = {
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        },
    },
}
