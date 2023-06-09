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

--- Open Microsoft Edge New Tab
function open_NewTab(name)
    return function()
        local browser = hs.appfinder.appFromName(name)
        local str_menu_item = { "File", "New Tab" }
        local menu_item = browser:findMenuItem(str_menu_item)
        if (menu_item) then
            browser:selectMenuItem(str_menu_item)
        end

        hs.timer.doAfter(0.001, function()
            local curr_win_name = hs.application.frontmostApplication():name()
            if curr_win_name:sub(-14) ~= "Microsoft Edge" then
                hs.application.frontmostApplication():hide()
            end
        end)
    end
end

--- Open Microsoft Edge New Window
function open_NewWindow(name)
    return function()
        local browser = hs.appfinder.appFromName(name)
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
hs.hotkey.bind({ "cmd", }, "D", open("Google Drive"))
hs.hotkey.bind({ "cmd" }, "1", open_url(URL))
hs.hotkey.bind({ "cmd" }, "2", open("Gmail Danilo"))
hs.hotkey.bind({ "cmd" }, "3", open("Microsoft Outlook"))
hs.hotkey.bind({ "cmd" }, "K", open("Google Keep"))
hs.hotkey.bind({ "cmd" }, "M", open("Google Maps"))
hs.hotkey.bind({ "cmd", "option" }, "C", open("Google Calendar"))
hs.hotkey.bind({ "cmd" }, "W", open("WhatsApp"))
hs.hotkey.bind({ "cmd" }, "X", open_NewTab("Microsoft Edge"))
--hs.hotkey.bind({ "cmd" }, "X", open_NewWindow("Microsoft Edge"))

