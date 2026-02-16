return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            sync_install = false,
            highlight = {
                enable = true
            }, -- TODO remove?
            indent = {
                enable = true
            },
            ensure_installed = {"bash", "c", "git_config", "git_rebase", "html", "javascript", "json", "lua",
                                "markdown_inline", "markdown", "nu", "powershell", "python", "query", "regex", "rust",
                                "toml", "tsx", "typescript", "vim", "yaml"}
        })
    end
}
