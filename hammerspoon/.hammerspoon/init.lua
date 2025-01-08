local HYPER = {"rctrl", "ralt", "rcmd"}
local SHIFT_HYPER = {"shift", "rctrl", "ralt", "rcmd"}

hs.hotkey.bind(SHIFT_HYPER, "r", function() hs.reload() end)

hs.hotkey.bind(SHIFT_HYPER, "c", function()
  hs.application.open("Hammerspoon")
end)

hs.hotkey.bind(HYPER, "m", function() hs.spaces.openMissionControl() end)

<<<<<<< Updated upstream
local changeFocus = function(cardinalDirection)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
=======
hs.window.animationDuration = 0.20
local GRID_MARGIN_PX = 5
local STACK_TAB_HEIGHT_PX = 40

local function initializeGrids()
  hs.grid.setMargins(hs.geometry.size(GRID_MARGIN_PX, GRID_MARGIN_PX))

  -- 6 columns supports both halves and thirds (as the LCM of 2 and 3).
  hs.grid.setGrid(hs.geometry.size(6, 1))
  --[[
  for _, screen in pairs(hs.screen.allScreens()) do
    local grid = hs.geometry.size(2, 1)
    if screen:frame().aspect > 2 then
      grid = hs.geometry.size(3, 1)
    end
    hs.grid.setGrid(grid, screen)
  end
  ]]
end
initializeGrids()

-- TODO: Consider calling grid.snap() after grid.show() to fix odd
--       discrepancy between their chosen shapes.
--       (See also: findStackedWindows)
hs.hotkey.bind(SHIFT_HYPER, "m", function() hs.grid.show() end)
hs.hotkey.bind(SHIFT_HYPER, "s", function() hs.grid.snap(hs.window.focusedWindow()) end)


local function assertValidCardinalDirection(cardinalDirection)
  assert(
    cardinalDirection == "north" or
    cardinalDirection == "south" or
    cardinalDirection == "east" or
    cardinalDirection == "west",
    string.format("invalid cardinalDirection: %s", cardinalDirection)
  )
end


local function findPerfectOverlap(window, frame)
  if frame == nil then
    local frame = window:frame()
  end
  for _, other in pairs(window:otherWindowsSameScreen()) do
    if frame:equals(other:frame()) then
      return other
    end
  end
  return nil
end


local function findStackedWindows(window)
  local stackedWindows = {}
  local frame = window:frame()
  for _, otherWindow in pairs(window:otherWindowsSameScreen()) do
    local other = otherWindow:frame()

    -- TODO: There's a slight difference in final window shapes when using
    --       grid.snap() and using the grid.show() UI. This workaround seems to
    --       handle it, but I'd like to understand the issue better.
    local width_diff = frame.w - other.w
    local width_close = math.abs(width_diff) <= GRID_MARGIN_PX

    local x_diff = frame.x - other.x
    local x_close = math.abs(x_diff) <= GRID_MARGIN_PX

    if x_close and width_close then
      table.insert(stackedWindows, otherWindow)
    end
  end
  -- Sort the windows such that the higher windows appear first.
  table.sort(stackedWindows, function(first, second)
    return first:frame().y < second:frame().y
  end)
  -- Append the current window to the stack rather than prepend;
  -- this looks and feels more natural.
  table.insert(stackedWindows, window)
  return stackedWindows
end


local function maybeStackWindows(window)
  local stackedWindows = findStackedWindows(window)
  if #stackedWindows == 1 then
    return
  end
  local fullFrame = window:frame()
  local newHeight = fullFrame.h - (STACK_TAB_HEIGHT_PX * (#stackedWindows - 1))

  for idx, stackedWindow in pairs(stackedWindows) do
    local newFrame = hs.geometry.rect(
      fullFrame.x,
      fullFrame.y + (STACK_TAB_HEIGHT_PX * (idx - 1)),
      fullFrame.w,
      newHeight
    )
    -- setFrameWithWorkarounds is required for correct edge handling,
    -- but the animation is super choppy.
    stackedWindow:setFrameWithWorkarounds(newFrame)
  end
end


local function maybeStackWindowOLD(window)
  local new_frame = window:frame()
  while findTopEdgeMatch(window, new_frame) ~= nil do
    new_frame = hs.geometry.rect(
      new_frame.x,
      new_frame.y + STACK_TAB_HEIGHT_PX,
      new_frame.w,
      new_frame.h - STACK_TAB_HEIGHT_PX
    )
  end
  -- setFrameWithWorkarounds doesn't seem to work reliably
  -- in this situation.
  window:setFrame(new_frame)
end


local function moveWindow(cardinalDirection)
  assertValidCardinalDirection(cardinalDirection)
  if cardinalDirection == "north" then
    hs.grid.pushWindowUp()
  elseif cardinalDirection == "south" then
    hs.grid.pushWindowDown()
  elseif cardinalDirection == "east" then
    hs.grid.pushWindowRight()
  else
    hs.grid.pushWindowLeft()
  end
  focusedWindow = hs.window.focusedWindow()
  maybeStackWindows(focusedWindow)
end
hs.hotkey.bind(SHIFT_HYPER, "h", function() moveWindow("west") end)
hs.hotkey.bind(SHIFT_HYPER, "j", function() moveWindow("south") end)
hs.hotkey.bind(SHIFT_HYPER, "k", function() moveWindow("north") end)
hs.hotkey.bind(SHIFT_HYPER, "l", function() moveWindow("east") end)


local function changeFocus(cardinalDirection)
  assertValidCardinalDirection(cardinalDirection)
>>>>>>> Stashed changes
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
hs.hotkey.bind(HYPER, "h", function() changeFocus("west") end)
hs.hotkey.bind(HYPER, "j", function() changeFocus("south") end)
hs.hotkey.bind(HYPER, "k", function() changeFocus("north") end)
hs.hotkey.bind(HYPER, "l", function() changeFocus("east") end)

<<<<<<< Updated upstream
hs.hotkey.bind(hyper, "h", function() changeFocus("west") end)
hs.hotkey.bind(hyper, "j", function()
  hs.window.focusedWindow():sendToBack()
end)
hs.hotkey.bind(hyper, "l", function() changeFocus("east") end)

local getLayoutsForScreen = function(screen)
=======
--[[
local function getLayoutsForScreen(screen)
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
local selectBestRectForMove = function(cardinalDirection, candidateRects, currentRect)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
=======
local function getClosestCardinalDirection(refRect, otherRect)
  -- angleTo returns radians on the interval [-pi, pi]
  local angle = refRect:angleTo(otherRect)
  local deg_45 = math.pi / 4
  local deg_135 = 3 * deg_45
  local deg_225 = -deg_135
  local deg_315 = -deg_45
  if (angle <= deg_45 and angle >= 0) or (angle >= deg_315 and angle <= 0) then
    return "east"
  elseif angle >= deg_45 and angle <= deg_135 then
    return "north"
  elseif (angle >= deg_135 and angle >= 0) or (angle <= deg_225 and angle <= 0) then
    return "west"
  elseif angle >= deg_225 and angle <= deg_315 then
    return "south"
  else
    assert(false, string.format("unhandled angle: %s", angle))
  end
end

local function selectBestRectForMove(cardinalDirection, candidateRects, currentRect)
  assertValidCardinalDirection(cardinalDirection)
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
local moveFocusedWindow = function(cardinalDirection)
  assert(
    cardinalDirection == "east" or cardinalDirection == "west",
    "invalid cardinalDirection"
  )
=======
local function moveFocusedWindow(cardinalDirection)
  assertValidCardinalDirection(cardinalDirection)
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
hs.hotkey.bind(shift_hyper, "h", function() moveFocusedWindow("west") end)
hs.hotkey.bind(shift_hyper, "l", function() moveFocusedWindow("east") end)
=======
hs.hotkey.bind(SHIFT_HYPER, "h", function() moveFocusedWindow("west") end)
hs.hotkey.bind(SHIFT_HYPER, "j", function() moveFocusedWindow("south") end)
hs.hotkey.bind(SHIFT_HYPER, "k", function() moveFocusedWindow("north") end)
hs.hotkey.bind(SHIFT_HYPER, "l", function() moveFocusedWindow("east") end)
]]
>>>>>>> Stashed changes


local function focusOnNearbyWindow(window)
  -- After minimizing the focused window, no window has focus. This breaks the
  -- navigation commands that rely on a focused window. If there are other
  -- windows on the screen, focus on one of them after minimizing. If there are
  -- no app windows, Finder will be focused.
  local otherWindows = window:otherWindowsSameScreen()
  if #otherWindows > 0 then
    otherWindows[1]:focus()
  end
end

<<<<<<< Updated upstream
hs.hotkey.bind(shift_hyper, "j", function()
  local focusedWindow = hs.window.focusedWindow()
  focusOnNearbyWindow(focusedWindow)
  focusedWindow:minimize()
end)

hs.hotkey.bind(hyper, "q", function()
=======
hs.hotkey.bind(HYPER, "q", function()
>>>>>>> Stashed changes
  local focusedWindow = hs.window.focusedWindow()
  focusOnNearbyWindow(focusedWindow)
  focusedWindow:close()
end)

<<<<<<< Updated upstream
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
=======
local function getOrCreateIndexedSpace(idx)
>>>>>>> Stashed changes
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
  hs.hotkey.bind(HYPER, tostring(i), function()
    hs.spaces.gotoSpace(getOrCreateIndexedSpace(i))
  end)

<<<<<<< Updated upstream
  hs.hotkey.bind(shift_hyper, tostring(i), function()
=======
  -- Broken in macOS 15
  -- See: https://github.com/Hammerspoon/hammerspoon/issues/3698
  --[[
  hs.hotkey.bind(SHIFT_HYPER, tostring(i), function()
>>>>>>> Stashed changes
    hs.spaces.moveWindowToSpace(
      hs.window.focusedWindow(),
      getOrCreateIndexedSpace(i)
    )
  end)
  ]]
end

hs.hotkey.bind(SHIFT_HYPER, "p", function()
  local window = hs.window.focusedWindow()
  print(hs.inspect(window), window:frame())
end)

if not hs.spaces.screensHaveSeparateSpaces() then
  hs.alert.show("WARNING: Screens have not been configured to use separate Spaces.")
end

hs.alert.show("Hammerspoon config loaded successfully")
