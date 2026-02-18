return { {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" }
}, { "hrsh7th/cmp-nvim-lsp" }, {
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp = require 'cmp'

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({
                    select = true
                }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({ {
                name = 'luasnip'
            }, {
                name = 'nvim_lsp'
            }, {
                name = 'buffer'
            } })
        })

        -- Set up capabilities for LSP servers
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Update vim.lsp.config with capabilities
        for _, server in ipairs({ 'lua_ls', 'powershell_es', 'ruff', 'taplo', 'yamlls' }) do
            if vim.lsp.config[server] then
                vim.lsp.config[server].capabilities = capabilities
            end
        end
    end
} }
