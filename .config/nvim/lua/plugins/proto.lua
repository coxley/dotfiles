return {
    { 'wfxr/protobuf.vim' },
    {
        'mfussenegger/nvim-lint',
        config = function()
            require('lint').linters_by_ft = {
                proto = { 'protolint' },
            }
        end,
    }
}
