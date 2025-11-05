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
        "<cmd>AutoSession search<cr>",
        desc = "Search sessions"
    }}
}
