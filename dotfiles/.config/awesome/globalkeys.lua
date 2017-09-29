local awful = require("awful")
local naughty = require("naughty")

function change_volume(how)
    os.execute(
        '~/.config/awesome/scripts/change_volume.sh "' .. how .. '"'
    )
end

local naughtybightid = nil
function change_brightness(how)
    os.execute("xbacklight " .. how)
    awful.spawn.with_line_callback("xbacklight", {
        stdout = function (line) 
            naughtybrightid = naughty.notify({
                text = string.format("%0.1f%%", tonumber(line)),
                title = "Brightness",
                replaces_id = naughtybrightid
            }).id
        end
    })
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
            function () awful.util.spawn("nautilus --no-desktop") end
        )
    )
    
    return globalkeys
end

return make_global_keys
