return {{
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            server = {
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItem = {
                                snippetSupport = false,
                            },
                        }
                    },
                },
            },
        }
    end,
}}
