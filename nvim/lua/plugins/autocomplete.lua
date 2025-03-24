return {{
    "L3MON4D3/LuaSnip",
    dependencies = {"saadparwaiz1/cmp_luasnip"}
}, {"hrsh7th/cmp-nvim-lsp"}, {
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
                documentation = cmp.config.window.bordered(),
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
            sources = cmp.config.sources({{
                name = 'luasnip'
            }, {
                name = 'nvim_lsp'
            }, {
                name = 'buffer'
            }})
        })

        -- Set up lspconfig.
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        -- NOTE: in order to add here, you need to add to lsp.lua
        local lspconfig = require 'lspconfig'
        lspconfig['lua_ls'].setup {
            capabilities = capabilities
        }
        lspconfig['pest_ls'].setup {
            capabilities = capabilities
        }
        lspconfig['powershell_es'].setup {
            capabilities = capabilities
        }
        lspconfig['ruff'].setup {
            capabilities = capabilities
        }
        lspconfig['taplo'].setup {
            capabilities = capabilities
        }
        lspconfig['yamlls'].setup {
            capabilities = capabilities
        }
    end
}}
