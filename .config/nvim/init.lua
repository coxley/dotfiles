-- A Linux workspace has no display server, so Neovim finds no clipboard tool on its own; use the
-- xclip shim the workspace tooling installs.
local xclip = vim.fn.expand("~/.local/bin/xclip")
if vim.fn.has("linux") == 1 and vim.fn.executable(xclip) == 1 then
    vim.g.clipboard = {
        name = "workspace-xclip",
        copy = {
            ["+"] = { xclip, "-i", "-selection", "clipboard" },
            ["*"] = { xclip, "-i", "-selection", "clipboard" },
        },
        paste = {
            ["+"] = { xclip, "-o", "-selection", "clipboard" },
            ["*"] = { xclip, "-o", "-selection", "clipboard" },
        },
        cache_enabled = 0,
    }
end

require("config.lazy")
