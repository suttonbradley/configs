return {
    "LittleMorph/copyright-updater.nvim",
    event = "BufModifiedSet",
    opts = {
        silent = true,
        return_cursor = true,
        style = {
            kind = "simple",
            simple = { force = true },
        },
        limiters = {
            range = "1,10",
        },
    },
}
