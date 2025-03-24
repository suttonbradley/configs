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
                -- TODO: toggle these?
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
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
            }}),
        })

        -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
        -- Set configuration for specific filetype.
        --[[ cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' },
                }, {
                    { name = 'buffer' },
                })
            })
            require("cmp_git").setup() ]] --

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({'/', '?'}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{
                name = 'buffer'
            }}
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{
                name = 'path'
            }}, {{
                name = 'cmdline'
            }}),
            matching = {
                disallow_symbol_nonprefix_matching = false
            }
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
