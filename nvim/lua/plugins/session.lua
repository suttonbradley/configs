return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = {}
        -- log_level = 'debug',
    },
    config = function()
        local plugin = require("auto-session")
        plugin.setup({})

        -- Vim session settings recommended on github page
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
    keys = {{
        "<leader>ss",
        "<cmd>SessionSearch<cr>",
        desc = "SessionSearch"
    }}
}
