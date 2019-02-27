local awful = require("awful")
local naughty = require("naughty")
local lain = require("lain")

local naughtyvolumeid = nil
function change_volume(how)
    local command = "volumectrl " .. how
    awful.spawn.easy_async_with_shell(
        command,
        function(stdout, stderr, reason, exit_code)
            naughtyvolumeid = naughty.notify({
                text = stdout:gsub("^%s*(.-)%s*$", "%1"),
                title = "Volume",
                replaces_id = naughtyvolumeid
            }).id
        end
    )
end

local naughtybrightid = nil
function change_brightness(how)
    local command = "brightness " .. how
    awful.spawn.easy_async_with_shell(
        command,
        function(stdout, stderr, reason, exit_code)
            naughtybrightid = naughty.notify({
                text = stdout:gsub("^%s*(.-)%s*$", "%1"),
                title = "Brightness",
                replaces_id = naughtybrightid
            }).id
        end
    )
end

local quake = lain.util.quake({
    app = 'zeal',
    height = 0.5,
    followtag = true,
})

function make_global_keys(modkey)
    local globalkeys = awful.util.table.join(
        -- Quake
        awful.key({ modkey}, "z",
            function () quake:toggle() end
        ),

        -- Audio keys
        awful.key({ }, "XF86AudioRaiseVolume",
            function () change_volume("+3") end
        ),
        awful.key({ }, "XF86AudioLowerVolume",
            function () change_volume("-3") end
        ),
        awful.key({"Shift"}, "XF86AudioRaiseVolume",
            function () change_volume("+1") end
        ),
        awful.key({"Shift"}, "XF86AudioLowerVolume",
            function () change_volume("-1") end
        ),
        awful.key({ }, "XF86AudioMute",
            function () change_volume("toggle") end
        ),

        awful.key({ modkey}, "F3",
            function () change_volume("+3") end
        ),
        awful.key({ modkey}, "F2",
            function () change_volume("-3") end
        ),
        awful.key({ modkey, "Shift"}, "F3",
            function () change_volume("+1") end
        ),
        awful.key({ modkey, "Shift"}, "F2",
            function () change_volume("-1") end
        ),
        awful.key({ modkey}, "F1",
            function () change_volume("toggle") end
        ),

        awful.key({ }, "XF86AudioMicMute",
            function () awful.spawn("amixer set Capture 1+ toggle", false) end
        ),
    
        -- Brightness
        awful.key({ }, "XF86MonBrightnessUp",
            function() change_brightness("+5%") end
        ),
        awful.key({ }, "XF86MonBrightnessDown",
            function() change_brightness("-5%") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessUp",
            function() change_brightness("+1%") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessDown",
            function() change_brightness("-1%") end
        ),
    
        -- Lock
    	awful.key({ }, "XF86Search",
              function ()
                  awful.spawn("sync")
                  awful.spawn("xautolock -enable")
                  awful.spawn("xautolock -locknow")
              end
    	),
    	awful.key({"Shift"}, "XF86Search",
              function () awful.spawn.with_shell("~/.bin/caffeine") end
    	),

        -- Touchpad Control
        awful.key({}, "XF86Explorer",
            function () awful.spawn.with_shell("~/.bin/touchpad_toggle") end
        ),
        awful.key({ modkey}, "F12",
            function () awful.spawn.with_shell("~/.bin/touchpad_toggle") end
        ),

        -- Media Keys
        awful.key({}, "XF86AudioNext",
            function () awful.spawn.with_shell("~/.bin/mediacontrol Next") end
        ),
        awful.key({}, "XF86AudioPrev",
            function () awful.spawn.with_shell("~/.bin/mediacontrol Previous") end
        ),
        awful.key({}, "XF86AudioPlay",
            function () awful.spawn.with_shell("~/.bin/mediacontrol PlayPause") end
        ),

        awful.key({ modkey, "Control"}, "F3",
            function () awful.spawn.with_shell("~/.bin/mediacontrol Next") end
        ),
        awful.key({ modkey, "Control"}, "F2",
            function () awful.spawn.with_shell("~/.bin/mediacontrol Previous") end
        ),
        awful.key({ modkey, "Control"}, "F1",
            function () awful.spawn.with_shell("~/.bin/mediacontrol PlayPause") end
        ),

        -- Toggle wibox.
        awful.key({ modkey}, "b",
                  function ()
                      local screen = awful.screen.focused()
                      screen.mywibox.visible = not screen.mywibox.visible
                  end,
                  {description = "toggle wibox on current screen"}
        ),

        -- Open file manager
        awful.key({ modkey}, "o",
            function () awful.spawn("nautilus --no-desktop") end
        )
    )
    
    return globalkeys
end

return make_global_keys
