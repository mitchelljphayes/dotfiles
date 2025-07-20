return {
  -- Make sure to set this up properly if you have lazy=true
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    file_types = { "markdown" },
    heading = {
      -- Turn off background highlighting for headers
      backgrounds = {},
      -- Use foreground colors only
      foregrounds = {
        "markdownH1",
        "markdownH2", 
        "markdownH3",
        "markdownH4",
        "markdownH5",
        "markdownH6",
      },
    },
    code = {
      -- Customize code block appearance
      style = "normal",
      width = "full",
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = "thin",
    },
    bullet = {
      -- Better bullet points
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      -- Nice checkbox icons
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    quote = {
      -- Subtle quote styling
      icon = "┃",
    },
    -- Disable some features for cleaner look
    pipe_table = {
      -- Keep tables simple
      style = "normal",
    },
    -- Performance settings
    render_modes = { "n", "c", "v" },
    anti_conceal = {
      enabled = true,
    },
  },
  ft = { "markdown" },
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
  },
}
