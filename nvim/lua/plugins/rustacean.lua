return { {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            features = "all",
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
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
