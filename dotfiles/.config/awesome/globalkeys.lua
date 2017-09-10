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
            function () change_volume("+5%") end
        ),
        awful.key({ }, "XF86AudioLowerVolume",
            function () change_volume("-5%") end
        ),
        awful.key({"Shift"}, "XF86AudioRaiseVolume",
            function () change_volume("+1%") end
        ),
        awful.key({"Shift"}, "XF86AudioLowerVolume",
            function () change_volume("-1%") end
        ),
        awful.key({ }, "XF86AudioMute",
            function () awful.util.spawn("amixer -D default sset Master toggle", false) end
        ),
        awful.key({ }, "XF86AudioMicMute",
            function () awful.util.spawn("amixer -D default sset Capture toggle", false) end
        ),
    
        -- Brightness
        awful.key({ }, "XF86MonBrightnessUp",
            function() awful.util.spawn("xbacklight +5%") end
        ),
        awful.key({ }, "XF86MonBrightnessDown",
            function() awful.util.spawn("xbacklight -5%") end
        ),
    
        -- Lock
    	awful.key({ modkey}, "l",
              function ()
                  awful.util.spawn("sync")
                  awful.util.spawn("xautolock -locknow")
              end
    	),
    	awful.key({ modkey, "Shift"}, "l",
              function () awful.util.spawn("xautolock -toggle") end
    	)

        --awful.key({"Mod1"}, "z",
            --function () awful.util.spawn("playerctl previous", false) end
        --),
        --awful.key({"Mod1"}, "x",
            --function () awful.util.spawn("playerctl stop", false) end
        --),
        --awful.key({"Mod1"}, "c",
            --function () awful.util.spawn("playerctl play-pause", false) end
        --),
        --awful.key({"Mod1"}, "v",
            --function () awful.util.spawn("playerctl next", false) end
        --),
    
        ---- multi-display keys
        --awful.key({modkey}, "o", awful.client.movetoscreen)
    )
    
    return globalkeys
end

return make_global_keys
