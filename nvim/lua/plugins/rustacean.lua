return { {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ['rust_analyzer'] = {
                        checkOnSave = {
                            command = "clippy"
                        }
                    }
                },
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
} }
