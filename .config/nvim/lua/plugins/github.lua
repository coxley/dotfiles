return {
    'pwntester/octo.nvim',
    config = function()
        require('octo').setup({
            use_local_fs = true,
        })
    end
}
