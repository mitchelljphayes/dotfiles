-- Enable CLI
require("hs.ipc")

-- Hammerspoon config for keyboard remapping
-- Uses CGEventTap which works on internal keyboard without Karabiner driver

-- Set to true to debug ctrl/escape detection
local DEBUG = false

local function dbg(msg)
    if DEBUG then print("[dbg] " .. msg) end
end

----------------------------------------------
-- Eventtap health monitoring
----------------------------------------------

local allTaps = {}

local function registerTap(tap)
    table.insert(allTaps, tap)
    return tap
end

local function ensureTapsRunning()
    for i, tap in ipairs(allTaps) do
        if not tap:isEnabled() then
            print("Hammerspoon: restarting dead eventtap #" .. i)
            tap:start()
        end
    end
end

local healthTimer = hs.timer.doEvery(5, ensureTapsRunning)

hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemDidWake
       or event == hs.caffeinate.watcher.screensDidUnlock
       or event == hs.caffeinate.watcher.screensDidWake then
        hs.timer.doAfter(1, ensureTapsRunning)
    end
end):start()

----------------------------------------------
-- Caps Lock → Control (hold) / Escape (tap)
-- Prereq: Set Caps Lock → Control in System Settings
----------------------------------------------

local ctrlPressTime = nil
local ctrlUsedAsModifier = false
local sendingEscape = false  -- guard against self-interception

registerTap(hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local flags = event:getFlags()
    local rawCode = event:getKeyCode()

    dbg("flagsChanged: keyCode=" .. rawCode ..
        " ctrl=" .. tostring(flags.ctrl) ..
        " shift=" .. tostring(flags.shift) ..
        " cmd=" .. tostring(flags.cmd) ..
        " alt=" .. tostring(flags.alt))

    if flags.ctrl then
        -- Control was just pressed
        ctrlPressTime = hs.timer.absoluteTime()
        ctrlUsedAsModifier = false
        dbg("ctrl DOWN — timer started")
    elseif ctrlPressTime ~= nil then
        -- A modifier was released and we had ctrl tracked
        -- (check ctrlPressTime to avoid triggering on other modifier releases)
        local elapsed = (hs.timer.absoluteTime() - ctrlPressTime) / 1e9
        dbg("ctrl UP — elapsed=" .. string.format("%.3f", elapsed) ..
            " usedAsModifier=" .. tostring(ctrlUsedAsModifier))

        if not ctrlUsedAsModifier and elapsed < 0.2 then
            dbg("SENDING ESCAPE")
            sendingEscape = true
            hs.eventtap.event.newKeyEvent(53, true):post()
            hs.eventtap.event.newKeyEvent(53, false):post()
            sendingEscape = false
        end
        ctrlPressTime = nil
    end

    return false
end))

----------------------------------------------
-- Ctrl+HJKL → Arrow Keys
----------------------------------------------

local arrowMap = {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
}

registerTap(hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, function(event)
    -- Ignore our own escape events
    if sendingEscape then return false end

    local flags = event:getFlags()
    local keyCode = event:getKeyCode()

    if flags.ctrl and ctrlPressTime then
        local char = hs.keycodes.map[keyCode]

        if char and arrowMap[char] then
            ctrlUsedAsModifier = true
            local arrowCode = hs.keycodes.map[arrowMap[char]]
            local isDown = (event:getType() == hs.eventtap.event.types.keyDown)
            local newEvent = hs.eventtap.event.newKeyEvent(arrowCode, isDown)

            -- Carry through shift/alt/cmd but strip ctrl
            local newFlags = {}
            if flags.shift then newFlags.shift = true end
            if flags.alt   then newFlags.alt   = true end
            if flags.cmd   then newFlags.cmd   = true end
            newEvent:setFlags(newFlags)

            return true, {newEvent}
        end

        -- Any other key while ctrl is held
        ctrlUsedAsModifier = true
    end

    return false
end))

----------------------------------------------
-- Start all taps
----------------------------------------------

for _, tap in ipairs(allTaps) do
    tap:start()
end

hs.alert.show("Keyboard remapping active")
print("Hammerspoon keyboard config loaded")
print("  - Caps Lock tap → Escape (DEBUG=" .. tostring(DEBUG) .. ")")
print("  - Caps Lock hold → Control")
print("  - Ctrl+HJKL → Arrow keys")
print("  - Eventtap health monitor: active")
