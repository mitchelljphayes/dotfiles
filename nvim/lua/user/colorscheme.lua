local colorscheme = "ayu-mirage"

require('ayu').setup({
    mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
    overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

--[[ vim.cmd [[ ]]
--[[   try ]]
--[[      colorscheme darkplus ]]
--[[     catch /^Vim\%((\a\+)\)\=:E185/ ]]
--[[     colorscheme default ]]
--[[     set background=dark ]]
--[[   end try ]]
--]]
