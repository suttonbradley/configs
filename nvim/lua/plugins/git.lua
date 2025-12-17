return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup()
    end,
    keys = { {
        "<leader>gb",
        "<cmd>Gitsigns blame<cr>",
        desc = "Show git blame using Gitsigns"
    } }
}
