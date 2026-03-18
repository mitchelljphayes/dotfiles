return {
  "ahkohd/difft.nvim",
  keys = {
    {
      "<leader>dt",
      function()
        ---@diagnostic disable-next-line: undefined-global
        if Difft.is_visible() then
          ---@diagnostic disable-next-line: undefined-global
          Difft.hide()
        else
          ---@diagnostic disable-next-line: undefined-global
          Difft.diff()
        end
      end,
      desc = "Toggle difftastic diff",
    },
  },
  config = function()
    require("difft").setup({
      command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff",
      auto_jump = true,
      no_diff_message = "No changes found",
      layout = "buffer", -- "buffer", "float", or "ivy"
    })
  end,
}
