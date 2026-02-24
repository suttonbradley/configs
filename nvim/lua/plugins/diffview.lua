return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>dv", "<cmd>DiffviewOpen<CR>",            desc = "Diffview open" },
        { "<leader>dc", "<cmd>DiffviewClose<CR>",           desc = "Diffview close" },
        { "<leader>dh", "<cmd>DiffviewFileHistory %<CR>",   desc = "File history (current file)" },
    },
    opts = {},
}
