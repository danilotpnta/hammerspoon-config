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


--- Safari counter 
-- hs.alert.show( hs.window:tabCount())


--- Open App
function open(name)
    return function()
        -- hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
        if name == 'Safari' then
            -- -- local browser = hs.appfinder.appFromName(name)
            -- hs.application.launchOrFocus(name)
            -- local focus_window =  hs.window.focusedWindow()
            -- local focus_window_id = focus_window:id()
            -- -- browser:activate()
            -- hs.alert.show(focus_window:title())
            -- -- hs.alert.show(focus_window_id)
            -- hs.alert.show(focus_window:tabCount())

            -- opening Tab
            local browser = hs.appfinder.appFromName(name)
            browser:activate()
            local str_menu_item = { "File", "New Tab" }
            local menu_item = browser:findMenuItem(str_menu_item)
            if (menu_item) then
                browser:selectMenuItem(str_menu_item)
            end


            local focus_window =  hs.window.focusedWindow()
            local focus_window_id = focus_window:id()
            hs.alert.show(focus_window_id)
            hs.alert.show(focus_window:tabCount())

        end

    end
end


function close(name)
    return function()

        function tprint (tbl, indent)
            if not indent then indent = 0 end
            for k, v in pairs(tbl) do
              formatting = string.rep("  ", indent) .. k .. ": "
              if type(v) == "table" then
                print(formatting)
                tprint(v, indent+1)
              elseif type(v) == 'boolean' then
                print(formatting .. tostring(v))      
              else
                print(formatting .. v)
              end
            end
          end

        local browser = hs.appfinder.appFromName(name)
        local str_menu_item = { "File", "Close Tab" }
        local menu_item = { "File", "Close Window" }

        local menu_item = browser:findMenuItem(str_menu_item)
        -- if (menu_item) then
        --     hs.alert.show('Here if')
        --     local tabWins = hs.tabs.tabWindows("Safari")
        --     local numTabs = #tabWins
        --     hs.alert.show(numTabs)

        --     browser:selectMenuItem(str_menu_item)
        -- else
        -- local closing_tab = browser:selectMenuItem({ "File", "Close Tab" })
        local menu_item2 = browser:findMenuItem({ "File", "Close Tab" })
        tprint(menu_item2)
        -- hs.alert.show( menu_item2[-3] )
        hs.alert.show( menu_item2['enabled']== false )

        -- if (closing_tab) then
        --     hs.alert.show("Not able to close Tab")
        --     local numMenuItems =  #browser:getMenuItems()
        --     -- hs.alert.show( numMenuItems )
        --     local numWindows = #hs.tabs.tabWindows(browser)
        --     hs.alert.show( numWindows )
        --     -- hs.alert.show( hs.window:tabCount() )
        -- end



    end
end
hs.hotkey.bind({ "cmd"}, "Q", close("Safari"))




--- Open Microsoft Edge New Tab
function open_NewTab(name)
    return function()
        local browser = hs.appfinder.appFromName(name)
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
function open_NewWindow(name)
    return function()
        local browser = hs.appfinder.appFromName(name)
        browser:activate()
        local str_menu_item = { "File", "New Window" }
        local menu_item = browser:findMenuItem(str_menu_item)
        if (menu_item) then
            browser:selectMenuItem(str_menu_item)
        end
    end
end

-- Opens URL
function open_url(URL)
    return function()
        hs.urlevent.openURL(URL)
    end
end

-- Binding Keys
local URL = "https://github.com/danilotpnta?tab=repositories"
hs.hotkey.bind({ "cmd" }, "E", open("Finder"))
hs.hotkey.bind({ "cmd" }, "Y", open("Youtube"))
hs.hotkey.bind({ "cmd" }, "T", open("Google Translate"))
hs.hotkey.bind({ "cmd","⌥" }, "D", open("Google Docs"))
hs.hotkey.bind({ "cmd","⌥" }, "S", open("Google Sheets"))
hs.hotkey.bind({ "cmd" }, "D", open("Google Drive"))
hs.hotkey.bind({ "cmd" }, "1", open_url(URL))
hs.hotkey.bind({ "cmd" }, "2", open("Gmail Danilo"))
hs.hotkey.bind({ "cmd" }, "3", open("Microsoft Outlook"))
hs.hotkey.bind({ "cmd" }, "K", open("Google Keep"))
hs.hotkey.bind({ "cmd" }, "M", open("Google Maps"))
hs.hotkey.bind({ "cmd", "option" }, "C", open("Google Calendar"))
hs.hotkey.bind({ "cmd" }, "W", open("WhatsApp"))
hs.hotkey.bind({ "cmd" }, "X", open_NewTab("Microsoft Edge"))
hs.hotkey.bind({ "cmd","⌥"}, "S", open("Safari"))
-- hs.hotkey.bind({ "cmd" }, "X", open_NewWindow("Microsoft Edge"))

