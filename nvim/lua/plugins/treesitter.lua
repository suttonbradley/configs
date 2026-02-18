return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter').install({
            "bash", "c", "git_config", "git_rebase", "html", "javascript", "json", "lua",
            "markdown_inline", "markdown", "nu", "powershell", "python", "query", "regex", "rust",
            "toml", "tsx", "typescript", "vim", "yaml"
        })

        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)
                vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
            end,
        })
    end
}
