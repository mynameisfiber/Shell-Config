local awful = require("awful")

function change_volume(how)
    os.execute(
        '~/.config/awesome/scripts/change_volume.sh "' .. how .. '"'
    )
end


function make_global_keys(modkey)
    local globalkeys = awful.util.table.join(
        -- Audio keys
        awful.key({ }, "XF86AudioRaiseVolume",
            function () change_volume("+3%") end
        ),
        awful.key({ }, "XF86AudioLowerVolume",
            function () change_volume("-3%") end
        ),
        awful.key({"Shift"}, "XF86AudioRaiseVolume",
            function () change_volume("+1%") end
        ),
        awful.key({"Shift"}, "XF86AudioLowerVolume",
            function () change_volume("-1%") end
        ),
        awful.key({ }, "XF86AudioMute",
            function () awful.util.spawn("amixer -D pulse set Master 1+ toggle", false) end
        ),
        awful.key({ }, "XF86AudioMicMute",
            function () awful.util.spawn("amixer -D pulse set Capture 1+ toggle", false) end
        ),
    
        -- Brightness
        awful.key({ }, "XF86MonBrightnessUp",
            function() awful.util.spawn("xbacklight +5%") end
        ),
        awful.key({ }, "XF86MonBrightnessDown",
            function() awful.util.spawn("xbacklight -5%") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessUp",
            function() awful.util.spawn("xbacklight +1%") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessDown",
            function() awful.util.spawn("xbacklight -1%") end
        ),
    
        -- Lock
    	awful.key({ }, "XF86Search",
              function ()
                  awful.util.spawn("sync")
                  awful.util.spawn("xautolock -enable")
                  awful.util.spawn("xautolock -locknow")
              end
    	),
    	awful.key({"Shift"}, "XF86Search",
              function () awful.util.spawn("xautolock -toggle") end
    	),

        -- Media Keys
        awful.key({}, "XF86AudioNext",
            function () awful.util.spawn("mediacontrol Next") end
        ),
        awful.key({}, "XF86AudioPrev",
            function () awful.util.spawn("mediacontrol Previous") end
        ),
        awful.key({}, "XF86AudioPlay",
            function () awful.util.spawn("mediacontrol PlayPause") end
        )
    )
    
    return globalkeys
end

return make_global_keys
