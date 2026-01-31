-- TODO: Replace with https://github.com/folke/snacks.nvim/blob/main/docs/image.md
return {
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty",
            processor = "magick_rock",
            integrations = {
                markdown = {
                    only_render_image_at_cursor = true,
                    only_render_image_at_cursor_mode = "popup",
                    floating_windows = true,
                },
            },
        }
    },
}
