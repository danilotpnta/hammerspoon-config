-- Autoreload Configuration
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("🟢 Shortcuts Enabled!")


--- Open App
function open(name)
    return function()

        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end

    end
end

--- Close App
function closeApp(appName)
    return function()
        local app = hs.application.find(appName)
        if app then
            app:kill()  
        else
            hs.alert.show(appName .. " is not running")
        end
    end
end

-- Closes a tab of Safari if able else send close keybinding to system
function close()
    return function()

        local focus_window =  hs.window.focusedWindow()
        local name_app_focus_window = focus_window:application():name()

        -- Only close option for Safari
        if (name_app_focus_window == "Safari") then

            -- Closes only one Tab from Safari
            hs.osascript.applescript([[
                tell application "Safari"
                    set tabcount to number of tabs in window 1
                    -- display dialog tabcount
                    if tabcount = 1 then
                        close window 1
                    else
                        -- close tab of window 1
                        tell application "System Events"
                            tell process "Safari"
                                -- activate
                                set frontmost to true
                                click menu item "Close Tab" of menu "File" of menu bar 1
                            end tell
                        end tell
                    end if
                end tell
            ]])


        -- For remainder Apps use Cmd+Q
        else
            hs.osascript.applescript([[
                -- tell application "System Events"
                --     set activeApp to name of first application process whose frontmost is true
                --     -- display dialog activeApp
                --     tell application activeApp 
                --         tell application "System Events" to keystroke "Q" using command down
                --         -- keystroke "Q" using command down
                --     end tell
                -- end tell

                tell application "System Events"
                    set activeApp to name of first application process whose frontmost is true
                end tell

                display dialog activeApp
                tell application "System Events" to ¬
                    tell application process activeApp
                        keystroke "Q" using command down
                    end tell

            ]])

            -- hs.eventtap.keyStroke({"cmd"}, "Q", 0, hs.application.frontmostApplication() )

        end
    end
end


--- Open browser with a new tab
function open_browser(webbrowser, choice)
    return function()
        -- Focus or launch the application
        hs.application.launchOrFocus(webbrowser)
    
        -- Get the active browser application
        local browser = hs.application.find(webbrowser)
        if browser then
            local str_menu_item = { "File", choice }
            local menu_item = browser:findMenuItem(str_menu_item)
            if menu_item then
                browser:selectMenuItem(str_menu_item)
            else
                hs.alert.show("Menu item not found")
            end
        else
            hs.alert.show(webbrowser .. " is not running")
        end
    end
end

-- Opens URL
local URL1 = "https://github.com/danilotpnta?tab=repositories"
function open_url(URL)
    return function()
        hs.urlevent.openURL(URL)
    end
end


-- Only close option for Safari
if (name_app_focus_window == "Safari") then
    -- hs.hotkey.bind({ "cmd"}, "Q", close())
    createManagedHotkey({ "cmd"}, "Q", close()):enable()
end


close_app = hs.hotkey.new('⌘', 'q', function()
    hs.osascript.applescript([[
        tell application "Safari"
            set tabcount to number of tabs in window 1
            -- display dialog tabcount
            if tabcount = 1 then
                close window 1
            else
                -- close tab of window 1
                tell application "System Events"
                    tell process "Safari"
                        -- activate
                        set frontmost to true
                        click menu item "Close Tab" of menu "File" of menu bar 1
                    end tell
                end tell
            end if
        end tell
    ]])
end)

hs.window.filter.new('Safari')
    :subscribe(hs.window.filter.windowFocused,function() close_app:enable() end)
    :subscribe(hs.window.filter.windowUnfocused,function() close_app:disable() end)


-- Function to create a hotkey with state tracking
local managedHotkeys = {}
function createManagedHotkey(mods, key, pressFn)
    local hk = hs.hotkey.new(mods, key, pressFn)
    table.insert(managedHotkeys, {hotkey = hk, enabled = false}) -- Initially disabled
    return hk
end

-- Table to store the last active window of specific applications
local lastWindow = {}

-- Function to toggle an app: focus it if not frontmost, or hide it if it is, while remembering its last window.
function toggleAndRememberApp(appName)
    return function()
        local app = hs.application.find(appName)
        if app and app:isFrontmost() then
            -- If the app is frontmost, store its focused window and hide the app.
            local currentWin = hs.window.focusedWindow()
            if currentWin and currentWin:application():name() == appName then
                lastWindow[appName] = currentWin
            end
            app:hide()
        else
            -- Launch or focus the app.
            hs.application.launchOrFocus(appName)
            -- After a short delay, try to re-focus the last window for this app if available.
            hs.timer.doAfter(0.5, function()
                local storedWin = lastWindow[appName]
                if storedWin and storedWin:isValid() and storedWin:isVisible() then
                    storedWin:focus()
                end
            end)
        end
    end
end

-- Set up a window filter for "ChatGPT Edge" to record the last active window whenever one is focused.
local chatGPTEdgeFilter = hs.window.filter.new("ChatGPT Edge")
chatGPTEdgeFilter:subscribe(hs.window.filter.windowFocused, function(win)
    lastWindow["ChatGPT Edge"] = win
end)


-- Define your hotkeys using the new function
createManagedHotkey({ "cmd" }, "2", open("Gmail")):enable()
createManagedHotkey({ "cmd" }, "E", open("Finder")):enable()
createManagedHotkey({ "cmd" }, "1", open_url(URL1)):enable()
createManagedHotkey({ "cmd" }, "Y", open("Youtube")):enable()
createManagedHotkey({ "cmd" }, "W", open("WhatsApp")):enable()
createManagedHotkey({ "cmd" }, "K", open("Google Keep")):enable()
createManagedHotkey({ "cmd" }, "M", open("Google Maps")):enable()
createManagedHotkey({ "cmd" }, "D", open("Google Drive")):enable()
createManagedHotkey({ "cmd" }, "T", open("Google Translate")):enable()
createManagedHotkey({ "cmd" }, "3", open("Microsoft Outlook")):enable()
createManagedHotkey({ "cmd", "option" }, "D", open("Docs")):enable()
createManagedHotkey({ "cmd", "option" }, "C", open("Google Calendar")):enable()

-- createManagedHotkey({ "option"}, "space", open("ChatGPT Edge")):enable()
-- createManagedHotkey({ "shift", "option"}, "space", open("Claude")):enable()
createManagedHotkey({ "option"}, "space", toggleAndRememberApp("ChatGPT Edge")):enable()
createManagedHotkey({ "cmd", "option"}, "space", toggleAndRememberApp("Claude")):enable()
createManagedHotkey({ "cmd"}, "X", open_browser("Safari", "New Tab")):enable()
createManagedHotkey({ "cmd" }, "X", open_browser("Microsoft Edge", "New Tab")):enable()


-- Toggle function to enable/disable all managed hotkeys
function toggleHotkeys()
    local anyEnabled = false
    for _, hk in ipairs(managedHotkeys) do
        if hk.enabled then
            anyEnabled = true
            break
        end
    end

    if anyEnabled then
        for _, hk in ipairs(managedHotkeys) do
            hk.hotkey:disable()
            hk.enabled = false
        end
        closeApp("Tiles")()
        hs.alert.show("🔴 Shortcuts Disabled!")
    else
        for _, hk in ipairs(managedHotkeys) do
            hk.hotkey:enable()
            hk.enabled = true
        end
        -- Launch Tiles app in the background
        hs.execute("/usr/bin/open -g -j -a Tiles", true)
        hs.alert.show("🟢 Shortcuts Enabled!")
    end
end

-- Bind the toggle function to a shortcut
hs.hotkey.bind({"cmd", "option", "control"}, "S", toggleHotkeys)


--- Border Barrier Blocking for Screen Sharing App
local screenSharingAppName = "Screen Sharing"
local eventTap = nil
local barrierHeight = 38
local lastBlockTime = 0
local blockCooldown = 0.2  -- Don't block again for 200ms after blocking once

local function enableBarrier()
    if not eventTap then
        eventTap = hs.eventtap.new({
            hs.eventtap.event.types.mouseMoved,
            hs.eventtap.event.types.leftMouseDragged,
            hs.eventtap.event.types.rightMouseDragged
        }, function(event)
            local app = hs.application.frontmostApplication()
            if app and app:name() == screenSharingAppName then
                local win = app:focusedWindow()
                if win and win:isFullScreen() then
                    local currentTime = hs.timer.secondsSinceEpoch()
                    local timeSinceLastBlock = currentTime - lastBlockTime
                    
                    local currentPos = hs.mouse.absolutePosition()
                    local screen = hs.mouse.getCurrentScreen()
                    local screenFrame = screen:fullFrame()
                    local topBarrier = screenFrame.y + barrierHeight
                    
                    local dy = event:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
                    local targetY = currentPos.y + dy
                    
                    -- Only block if:
                    -- 1. Haven't blocked recently (cooldown expired)
                    -- 2. Crossing barrier going up
                    if timeSinceLastBlock > blockCooldown then
                        if currentPos.y >= topBarrier and targetY < topBarrier and dy < 0 then
                            hs.mouse.absolutePosition({
                                x = currentPos.x,
                                y = topBarrier
                            })
                            lastBlockTime = currentTime
                            return true
                        end
                    end
                end
            end
            return false
        end)
        
        eventTap:start()
        hs.alert.show("Cooldown barrier enabled", 1)
    end
end

local function disableBarrier()
    if eventTap then
        eventTap:stop()
        eventTap = nil
        hs.alert.show("Barrier disabled", 1)
    end
end

appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if appName == screenSharingAppName then
        if eventType == hs.application.watcher.activated then
            hs.timer.doAfter(0.1, enableBarrier)
        elseif eventType == hs.application.watcher.deactivated then
            disableBarrier()
        end
    end
end)

appWatcher:start()

local app = hs.application.get(screenSharingAppName)
if app and app:isFrontmost() then
    enableBarrier()
end
