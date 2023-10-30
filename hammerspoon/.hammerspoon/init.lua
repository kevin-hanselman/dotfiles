local hyper = {"rctrl", "ralt", "rcmd"}
local shift_hyper = {"shift", "rctrl", "ralt", "rcmd"}

hs.window.animationDuration = 0.20

hs.hotkey.bind(shift_hyper, "r", function() hs.reload() end)

hs.hotkey.bind(shift_hyper, "c", function()
  hs.application.open("Hammerspoon")
end)

hs.hotkey.bind(hyper, "m", function() hs.spaces.openMissionControl() end)

local changeFocus = function(cardinalDirection)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
  local couldFocusOnWindow = false
  if cardinalDirection == "west" then
    couldFocusOnWindow = hs.window.focusedWindow():focusWindowWest()
  else
    couldFocusOnWindow = hs.window.focusedWindow():focusWindowEast()
  end

  if couldFocusOnWindow then
    -- Make the mouse follow the change in focus by pointing at the center of
    -- the newly focused window.
    hs.mouse.absolutePosition(hs.window.focusedWindow():frame().center)
  else
    -- If there is no window to focus on in the given direction, check for an
    -- adjacent screen. If one exists, the screen is likely empty. Focus on the
    -- empty desktop of that screen.
    local adjacentScreen = nil
    if cardinalDirection == "west" then
      adjacentScreen = hs.screen.mainScreen():toWest()
    else
      adjacentScreen = hs.screen.mainScreen():toEast()
    end
    if adjacentScreen ~= nil then
      -- A hack to focus on the desktop of the empty adjacent screen.
      -- Apparently, macOS treats the "desktop" as a single instance of
      -- "Finder" that spans all screens. Calling hs.window.desktop():focus()
      -- will not necessarily focus on the correct screen.
      -- A nice side-effect of this hack is that it also moves the mouse.
      hs.eventtap.leftClick(adjacentScreen:frame().center)
    end
  end
end

hs.hotkey.bind(hyper, "h", function() changeFocus("west") end)
hs.hotkey.bind(hyper, "j", function()
  hs.window.focusedWindow():sendToBack()
end)
hs.hotkey.bind(hyper, "l", function() changeFocus("east") end)

local getLayoutsForScreen = function(screen)
  local layouts = nil
  if screen:frame().aspect > 2 then
    layouts = {
      hs.geometry.rect(0, 0, 0.3333, 1), -- left third
      hs.geometry.rect(0.3333, 0, 0.3333, 1), -- middle third
      hs.geometry.rect(0.6667, 0, 0.3333, 1), -- last third
    }
  else
    layouts = {
      hs.layout.left50,
      hs.layout.right50,
    }
  end
  for k, v in pairs(layouts) do
    layouts[k] = screen:fromUnitRect(v)
  end
  return layouts
end

local selectBestRectForMove = function(cardinalDirection, candidateRects, currentRect)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
  local bestDistance = 99999999
  local bestRect = nil
  for _, candidateRect in pairs(candidateRects) do
    local xDiff = currentRect.center.x - candidateRect.center.x
    local correctDirection = false
    if cardinalDirection == "east" then
      correctDirection = xDiff < 0
    else
      correctDirection = xDiff > 0
    end
    dist = currentRect:distance(candidateRect)
    -- If dist is really small, our current rect is probably already
    -- at the given candidate location; ignore a no-op move.
    if dist > 0.01 and correctDirection and dist < bestDistance then
      bestDistance = dist
      bestRect = candidateRect
    end
  end
  return bestRect
end

local moveFocusedWindow = function(cardinalDirection)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
  local focusedWindow = hs.window.focusedWindow()
  local screen = hs.screen.mainScreen()
  local adjacentScreen = nil

  if cardinalDirection == "east" then
    adjacentScreen = screen:toEast(nil, true)
  else
    adjacentScreen = screen:toWest(nil, true)
  end

  local candidateRects = getLayoutsForScreen(screen)

  if adjacentScreen ~= nil then
    local adjacentRects = getLayoutsForScreen(adjacentScreen)
    for _, v in pairs(adjacentRects) do
      table.insert(candidateRects, v)
    end
  end

  local moveRect = selectBestRectForMove(
    cardinalDirection,
    candidateRects,
    focusedWindow:frame()
  )

  if moveRect ~= nil then
    focusedWindow:move(moveRect)
  end
end

hs.hotkey.bind(shift_hyper, "h", function() moveFocusedWindow("west") end)
hs.hotkey.bind(shift_hyper, "l", function() moveFocusedWindow("east") end)

local focusOnNearbyWindow = function(window)
  -- After minimizing the focused window, no window has focus. This breaks the
  -- navigation commands that rely on a focused window. If there are other
  -- windows on the screen, focus on one of them after minimizing. If there are
  -- no app windows, Finder will be focused.
  local otherWindows = window:otherWindowsSameScreen()
  if #otherWindows > 0 then
    otherWindows[1]:focus()
  end
end

hs.hotkey.bind(shift_hyper, "j", function()
  local focusedWindow = hs.window.focusedWindow()
  focusOnNearbyWindow(focusedWindow)
  focusedWindow:minimize()
end)

hs.hotkey.bind(hyper, "q", function()
  local focusedWindow = hs.window.focusedWindow()
  focusOnNearbyWindow(focusedWindow)
  focusedWindow:close()
end)

hs.hotkey.bind(shift_hyper, "k", function()
  local focusedWindow = hs.window.focusedWindow()
  -- TODO: If Finder is focused, un-minimize a window from the list of minimized
  -- windows on the current space/screen.
  --if focusedWindow:application():name() == "Finder" then
  --  print(hs.inspect(hs.screen.mainScreen()))
  --end
  focusedWindow:maximize()
end)

local getOrCreateIndexedSpace = function(idx)
  -- Put a hard limit on the number of Spaces this function may create.
  assert(1 <= idx and idx <= 10, "index out of bounds")
  local spaces = hs.spaces.spacesForScreen()
  if idx <= #spaces then
    return spaces[idx]
  end
  -- Add spaces until we have the index position requested.
  for i = 1,(idx - #spaces) do
    hs.spaces.addSpaceToScreen()
  end
  return hs.spaces.spacesForScreen()[idx]
end

for i = 1,4 do
  hs.hotkey.bind(hyper, tostring(i), function()
    hs.spaces.gotoSpace(getOrCreateIndexedSpace(i))
  end)

  hs.hotkey.bind(shift_hyper, tostring(i), function()
    hs.spaces.moveWindowToSpace(
      hs.window.focusedWindow(),
      getOrCreateIndexedSpace(i)
    )
  end)
end

if not hs.spaces.screensHaveSeparateSpaces() then
  hs.alert.show("WARNING: Screens have not been configured to use separate Spaces.")
end

hs.alert.show("Hammerspoon config loaded successfully")
