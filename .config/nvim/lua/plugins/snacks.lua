return {
    "folke/snacks.nvim",
    keys = {
        { '<leader>n', ':lua Snacks.words.jump(1, true)<CR>', desc = "Next LSP word" },
    },
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        words = { enabled = true },
        gitbrowse = { enabled = true },
    },
}
