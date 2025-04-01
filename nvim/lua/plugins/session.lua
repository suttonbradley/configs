return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        -- Avoid session clutter!
        auto_create = false
    },
    keys = { -- "s" for "session"
    {
        "<leader>ss",
        "<cmd>SessionSearch<cr>",
        desc = "Search sessions"
    }, {
        -- Create session for the dir that was passed to nvim (or working dir if none)
        "<leader>sc",
        "<cmd>SessionSave<cr>",
        desc = "Create session"
    }}
}
