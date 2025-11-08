return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        -- Avoid session clutter!
        auto_create = false,
        auto_restore_last_session = true,
    },
    keys = { -- "s" for "session"
    {
        "<leader>ss",
        "<cmd>AutoSession search<cr>",
        desc = "Search sessions"
    }}
}
