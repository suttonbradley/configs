return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local plugin_dir = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
        vim.opt.runtimepath:append(plugin_dir .. '/runtime')
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
                vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
            end,
        })
    end
}
