return {
    "folke/todo-comments.nvim",
    event = 'VeryLazy',
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
    cmd = {
        "TodoTelescope",
        "TodoLocList",
        "TodoTrouble",
        "TodoQuickFix",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {}
}
