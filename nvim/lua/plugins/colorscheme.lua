return {
  "navarasu/onedark.nvim",
  name = "onedark",
  priority = 1000,
  config = function()
    local onedark = require('onedark')
    local current_style = nil

    -- Apply theme based on vim.o.background
    local function apply_theme()
      local style = vim.o.background -- "dark" or "light"
      if style ~= current_style then
        current_style = style
        onedark.setup { style = style }
        onedark.load()
      end
    end

    -- Helper to write escape sequences (with tmux passthrough if needed)
    local function write_escape(seq)
      if vim.env.TMUX then
        -- Wrap in tmux DCS passthrough sequence
        io.stdout:write("\027Ptmux;" .. seq:gsub("\027", "\027\027") .. "\027\\")
      else
        io.stdout:write(seq)
      end
      io.stdout:flush()
    end

    -- Enable mode 2031 - request unsolicited theme change notifications
    -- Ghostty will send DSR when system theme changes
    write_escape("\027[?2031h")

    -- Detect initial theme from terminal (OSC 11 query)
    -- Neovim does this automatically and sets vim.o.background
    apply_theme()

    -- Listen for background changes from terminal (mode 2031)
    -- Ghostty sends notifications when system theme changes
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = apply_theme,
      desc = "Update colorscheme when terminal reports theme change",
    })

    -- Fallback: re-check on focus (for terminals without mode 2031)
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        -- Query terminal for background color (OSC 11)
        -- Neovim handles the response and updates vim.o.background
        write_escape("\027]11;?\027\\")
        -- Small delay to allow response, then apply
        vim.defer_fn(apply_theme, 50)
      end,
      desc = "Query terminal for theme on focus",
    })

    -- Cleanup: disable mode 2031 on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        write_escape("\027[?2031l")
      end,
      desc = "Disable theme change notifications on exit",
    })
  end,
}
-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'catppuccin'
--   end,
-- }
-- {
--   'Shatur/neovim-ayu',
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'ayu-mirage'
--   end,
-- }
-- 
-- return {
--   "EdenEast/nightfox.nvim",
--   name = "carbonfox",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'carbonfox'
--   end,
-- }
