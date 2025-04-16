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
                    "clangd",
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
            -- NOTE: completions won't work without adding to autocomplete.lua
            lspconfig.clangd.setup({})
            lspconfig.pest_ls.setup({})
            lspconfig.powershell_es.setup({})
            lspconfig.ruff.setup({})
            -- lspconfig.rust_analyzer.setup({}) -- NOTE: purposefully omitted due to rustacean plugin
            lspconfig.taplo.setup({})
            lspconfig.yamlls.setup({})

            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true })

            vim.lsp.inlay_hint.enable(true)
        end
    },
}
