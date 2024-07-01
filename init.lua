--[[ 
    ---------- HAMMERSPOON CONFIGURATION ------------
    Description: A lua approach to speed up your workflow 
    by: Danilo Toapanta


    ---------------- RESOURCES ----------------------
    -- To able to use Apple script
    hs.osascript.applescript()

    -- Source how to open New Tab Safari next to current
    https://www.cultofmac.com/691905/how-to-force-safari-tabs-open-at-end-of-tab-bar/

     -- Closes Tab, but depricated due to lag
     -- Used in function: close()        
    hs.appfinder.appFromName("Safari"):activate()

    local browser = hs.appfinder.appFromName("Safari")
    local menu_item = browser:findMenuItem({ "File", "Close Tab" })            

    -- If Close Tab still enabled
    if (menu_item['enabled'] == false) then
        browser:selectMenuItem({ "File", "Close Window" })
    else
        -- When only one tab remaining, close it 
        browser:selectMenuItem({ "File", "Close Window" })
    end
    
    -- Docs
    https://www.hammerspoon.org/docs/hs.eventtap.html#newKeyEvent
    https://www.hammerspoon.org/docs/hs.hotkey.html#new
    https://www.hammerspoon.org/docs/hs.eventtap.event.html#newKeyEventSequence
    https://www.hammerspoon.org/docs/hs.application.html#name

    -- Open Tabs
    https://zzamboni.org/post/just-enough-lua-to-be-productive-in-hammerspoon-part-2/
]]

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
hs.alert.show("New changes applied")


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

--- Open Microsoft Edge New Tab
function open_NewTab(webbrowser)
    return function()
        local browser = hs.appfinder.appFromName(webbrowser)
        browser:activate()
        local str_menu_item = { "File", "New Tab" }
        local menu_item = browser:findMenuItem(str_menu_item)
        if (menu_item) then
            browser:selectMenuItem(str_menu_item)
            --hs.alert.show(hs.application.frontmostApplication():name())
        end

    end
end

--- Open Microsoft Edge New Window
function open_NewWindow(webbrowser)
    return function()
        local browser = hs.appfinder.appFromName(webbrowser)
        browser:activate()
        local str_menu_item = { "File", "New Window" }
        local menu_item = browser:findMenuItem(str_menu_item)
        if (menu_item) then
            browser:selectMenuItem(str_menu_item)
        end
    end
end

-- Opens URL
local URL = "https://github.com/danilotpnta?tab=repositories"
function open_url(URL)
    return function()
        hs.urlevent.openURL(URL)
    end
end

-- Binding Keys
-- hs.hotkey.bind({ "cmd" }, "E", open("Finder"))
-- hs.hotkey.bind({ "cmd" }, "Y", open("Youtube"))
-- hs.hotkey.bind({ "cmd" }, "T", open("Google Translate"))
-- hs.hotkey.bind({ "cmd","⌥" }, "D", open("Google Docs"))
-- hs.hotkey.bind({ "cmd","⌥" }, "S", open("Google Sheets"))
-- hs.hotkey.bind({ "cmd" }, "D", open("Google Drive"))
-- hs.hotkey.bind({ "cmd" }, "1", open_url(URL))
-- hs.hotkey.bind({ "cmd" }, "2", open("Gmail Danilo"))
-- hs.hotkey.bind({ "cmd" }, "3", open("Microsoft Outlook"))
-- hs.hotkey.bind({ "cmd" }, "K", open("Google Keep"))
-- hs.hotkey.bind({ "cmd" }, "M", open("Google Maps"))
-- hs.hotkey.bind({ "cmd", "option" }, "C", open("Google Calendar"))
-- hs.hotkey.bind({ "cmd" }, "W", open("WhatsApp"))
-- hs.hotkey.bind({ "cmd"}, "X", open_NewTab("Safari"))
-- hs.hotkey.bind({ "cmd" }, "X", open_NewTab("Microsoft Edge"))
-- hs.hotkey.bind({ "cmd" }, "X", open_NewWindow("Microsoft Edge"))


-- local focus_window =  hs.window.focusedWindow()
-- local name_app_focus_window = focus_window:application():name()
-- hs.alert.show(name_app_focus_window)

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

-- Define your hotkeys using the new function
createManagedHotkey({ "cmd" }, "E", open("Finder")):enable()
createManagedHotkey({ "cmd" }, "Y", open("Youtube")):enable()
createManagedHotkey({ "cmd" }, "T", open("Google Translate")):enable()
createManagedHotkey({ "cmd","⌥" }, "D", open("Google Docs")):enable()
createManagedHotkey({ "cmd","⌥" }, "S", open("Google Sheets")):enable()
createManagedHotkey({ "cmd" }, "D", open("Google Drive")):enable()
createManagedHotkey({ "cmd" }, "1", open_url(URL)):enable()
createManagedHotkey({ "cmd" }, "2", open("Gmail Danilo")):enable()
createManagedHotkey({ "cmd" }, "3", open("Microsoft Outlook")):enable()
createManagedHotkey({ "cmd" }, "K", open("Google Keep")):enable()
createManagedHotkey({ "cmd" }, "M", open("Google Maps")):enable()
createManagedHotkey({ "cmd", "option" }, "C", open("Google Calendar")):enable()
createManagedHotkey({ "cmd" }, "W", open("WhatsApp")):enable()
createManagedHotkey({ "cmd"}, "X", open_NewTab("Safari")):enable()
createManagedHotkey({ "cmd" }, "X", open_NewTab("Microsoft Edge")):enable()


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
        -- These calls actually execute the functions returned by closeApp and open
        closeApp("Tiles")()
        closeApp("BetterTouchTool")()
        hs.alert.show("Hotkeys Disabled")
    else
        for _, hk in ipairs(managedHotkeys) do
            hk.hotkey:enable()
            hk.enabled = true
        end
        -- These calls actually execute the functions returned by closeApp and open
        open("Tiles")()
        open("BetterTouchTool")()
        hs.alert.show("Hotkeys Enabled")
    end
end

-- Bind the toggle function to a shortcut
hs.hotkey.bind({"cmd", "option", "control"}, "S", toggleHotkeys)
