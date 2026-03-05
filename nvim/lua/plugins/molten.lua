return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
    },
    {
        "3rd/image.nvim",
        build = false, -- don't build the rock, use magick_cli
        lazy = false,  -- must load eagerly for hijack_file_patterns to work
        opts = {
            backend = "kitty",
            processor = "magick_cli",
            max_width_window_percentage = 80,
            max_height_window_percentage = 80,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            -- Render image files inline when opened in nvim
            hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.bmp", "*.ico", "*.svg" },
            -- tmux support
            tmux_show_only_in_active_window = true,
        },
    },
}
