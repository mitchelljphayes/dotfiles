-- Enable CLI
require("hs.ipc")

-- Hammerspoon config for keyboard remapping
-- Uses CGEventTap which works on internal keyboard!

----------------------------------------------
-- Caps Lock → Control (hold) / Escape (tap)
-- Note: Set Caps Lock → Control in System Settings first
----------------------------------------------

local ctrlTapTime = nil
local ctrlUsedAsModifier = false

local ctrlWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local flags = event:getFlags()
    
    if flags.ctrl then
        -- Control pressed
        ctrlTapTime = hs.timer.absoluteTime()
        ctrlUsedAsModifier = false
    else
        -- Control released
        if ctrlTapTime and not ctrlUsedAsModifier then
            local elapsed = (hs.timer.absoluteTime() - ctrlTapTime) / 1e9
            if elapsed < 0.2 then
                -- Quick tap - send Escape
                hs.eventtap.keyStroke({}, "escape", 0)
            end
        end
        ctrlTapTime = nil
    end
    
    return false
end)

local modifierWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    if flags.ctrl then
        ctrlUsedAsModifier = true
    end
    return false
end)

ctrlWatcher:start()
modifierWatcher:start()

----------------------------------------------
-- Control + HJKL → Arrow Keys
----------------------------------------------

hs.hotkey.bind({"ctrl"}, "h", function()
    ctrlUsedAsModifier = true
    hs.eventtap.keyStroke({}, "left", 0)
end, nil, function()
    hs.eventtap.keyStroke({}, "left", 0)
end)

hs.hotkey.bind({"ctrl"}, "j", function()
    ctrlUsedAsModifier = true
    hs.eventtap.keyStroke({}, "down", 0)
end, nil, function()
    hs.eventtap.keyStroke({}, "down", 0)
end)

hs.hotkey.bind({"ctrl"}, "k", function()
    ctrlUsedAsModifier = true
    hs.eventtap.keyStroke({}, "up", 0)
end, nil, function()
    hs.eventtap.keyStroke({}, "up", 0)
end)

hs.hotkey.bind({"ctrl"}, "l", function()
    ctrlUsedAsModifier = true
    hs.eventtap.keyStroke({}, "right", 0)
end, nil, function()
    hs.eventtap.keyStroke({}, "right", 0)
end)

----------------------------------------------
-- Ready
----------------------------------------------

hs.alert.show("Keyboard remapping active")
print("Hammerspoon keyboard config loaded")
print("  - Caps Lock tap → Escape")
print("  - Caps Lock hold → Control") 
print("  - Ctrl+HJKL → Arrow keys")
