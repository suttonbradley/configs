return {
    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                -- Available LSP servers at: https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
                ensure_installed = {
                    "lua_ls",
                    "pest_ls",
                    "powershell_es",
                    "ruff", --python
                    -- "rust_analyzer", -- NOTE: must be installed by rustup, not Mason, for rustacean plugin
                    "taplo", -- toml
                    "yamlls",
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                -- Avoid warnings r.e. unfound global 'vim'
                settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
            })
            lspconfig.pest_ls.setup({})
            lspconfig.powershell_es.setup({})
            lspconfig.ruff.setup({})
            -- lspconfig.rust_analyzer.setup({}) -- NOTE: purposefully omitted due to rustacean plugin
            lspconfig.taplo.setup({})
            lspconfig.yamlls.setup({})

            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    },
}
