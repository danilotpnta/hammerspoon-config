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

--hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(paths)
--    reloadConfig(paths) end):start()

hs.alert.show("New changes applied")

--
function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

hs.hotkey.bind({ "cmd" }, "E", open("Finder"))
hs.hotkey.bind({ "cmd" }, "Y", open("Youtube"))
hs.hotkey.bind({ "cmd" }, "T", open("Google Translate"))
hs.hotkey.bind({ "cmd", "alt" }, "D", open("Google Drive Space Society Twente"))
hs.hotkey.bind({ "cmd", }, "D", open("Google Drive"))
hs.hotkey.bind({ "cmd" }, "2", open("Gmail Danilo"))
hs.hotkey.bind({ "cmd" }, "3", open("Microsoft Outlook"))
hs.hotkey.bind({ "cmd" }, "4", open("Gmail Fatema"))
hs.hotkey.bind({ "cmd" }, "K", open("Google Keep"))
hs.hotkey.bind({ "cmd" }, "M", open("Google Maps"))
hs.hotkey.bind({ "cmd", "option" }, "C", open("Google Calendar"))
hs.hotkey.bind({ "cmd", "option", "shift" }, "C", open("Google Calendar Fatema"))
hs.hotkey.bind({ "cmd" }, "W", open("WhatsApp"))

-- Focus only in Edge
--local wf=hs.window.filter
--wf:setAppFilter(appname,false)
--
--

--
function open_NewTab(name)
    --hs.appfinder.appFromName("Microsoft Edge"):activate()

    return function()
        local curr_win_name = hs.application.frontmostApplication():name()
        local browser = hs.appfinder.appFromName("Microsoft Edge")
        local str_menu_item = { "File", "New Tab" }


        --if ppl == "Open_NewTab" then
        --    str_menu_item = { "File", "New Tab" }
        --end

        local menu_item = browser:findMenuItem(str_menu_item)
        if (menu_item) then
            browser:selectMenuItem(str_menu_item)
        end
        if curr_win_name:sub(-14) ~= "Microsoft Edge" then
            hs.application.frontmostApplication():hide()
        end

    end
end

--- open different Microsoft Edge users
hs.hotkey.bind({ "cmd" }, "X", open_NewTab("Microsoft Edge"))
