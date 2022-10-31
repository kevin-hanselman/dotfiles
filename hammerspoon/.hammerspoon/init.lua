local hyper = {"rctrl", "ralt", "rcmd"}
local shift_hyper = {"shift", "rctrl", "ralt", "rcmd"}

hs.window.animationDuration = 0.20

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
  hs.alert.show("Reloaded Hammerspoon config")
end)

hs.hotkey.bind(hyper, "m", function()
  hs.spaces.openMissionControl()
end)

hs.hotkey.bind(hyper, "h", function()
  hs.window.focusedWindow():focusWindowWest()
end)

hs.hotkey.bind(hyper, "l", function()
  hs.window.focusedWindow():focusWindowEast()
end)

hs.hotkey.bind(shift_hyper, "h", function()
  local focusedWindow = hs.window.focusedWindow()
  local origFrame = focusedWindow:frame()
  focusedWindow:move(hs.layout.left50)
  local newFrame = focusedWindow:frame()
  -- If the window hasn't moved, we're already in the correct position. If so,
  -- push the window to the adjacent side of the adjacent screen.
  if origFrame:equals(newFrame) then
    -- This would retain the left50 positioning on the new screen.
    --focusedWindow:moveOneScreenWest()
    local newScreen = focusedWindow:screen():toWest()
    if newScreen ~= nil then
      focusedWindow:move(hs.layout.right50, newScreen)
    end
  end
end)

hs.hotkey.bind(shift_hyper, "l", function()
  local focusedWindow = hs.window.focusedWindow()
  local origFrame = focusedWindow:frame()
  focusedWindow:move(hs.layout.right50)
  local newFrame = focusedWindow:frame()
  -- If the window hasn't moved, we're already in the correct position. If so,
  -- push the window to the adjacent side of the adjacent screen.
  if origFrame:equals(newFrame) then
    local newScreen = focusedWindow:screen():toEast()
    if newScreen ~= nil then
      focusedWindow:move(hs.layout.left50, newScreen)
    end
  end
end)

hs.hotkey.bind(shift_hyper, "j", function()
  hs.window.focusedWindow():sendToBack()
end)

hs.hotkey.bind(shift_hyper, "k", function()
  hs.window.focusedWindow():maximize()
end)

