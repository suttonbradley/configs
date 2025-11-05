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
            vim.lsp.config.lua_ls = {
                cmd = { 'lua-language-server' },
                settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
            }
            vim.lsp.config.clangd = { cmd = { 'clangd' } }
            vim.lsp.config.pest_ls = { cmd = { 'pest-language-server' } }
            vim.lsp.config.powershell_es = { cmd = { 'PowerShellEditorServices' } }
            vim.lsp.config.ruff = { cmd = { 'ruff', 'server' } }
            vim.lsp.config.taplo = { cmd = { 'taplo', 'lsp', 'stdio' } }
            vim.lsp.config.yamlls = { cmd = { 'yaml-language-server', '--stdio' } }

            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true })

            vim.lsp.inlay_hint.enable(true)
        end
    },
}
