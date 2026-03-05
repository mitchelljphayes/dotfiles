-- Open PDFs and ePubs with system viewer
-- Images are handled by image.nvim (see molten.lua)

return {
  {
    "media-viewer",
    dir = vim.fn.stdpath("config") .. "/lua/media-viewer",
    virtual = true,
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("BufReadCmd", {
        pattern = { "*.pdf", "*.epub" },
        callback = function(args)
          local filepath = vim.fn.fnamemodify(vim.fn.expand(args.match), ":p")
          local buf = args.buf

          -- Open with system viewer (Preview.app on macOS)
          vim.ui.open(filepath)
          vim.notify("Opened in system viewer: " .. vim.fn.fnamemodify(filepath, ":t"), vim.log.levels.INFO)

          -- Clean up the empty buffer
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end)
        end,
        desc = "Open PDFs and ePubs with system viewer",
      })
    end,
  },
}
