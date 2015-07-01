local M = awful.util.table.join(
    -- Audio keys
    awful.key({ }, "XF86AudioRaiseVolume",
        function () awful.util.spawn("pactl -- set-sink-volume 1 +5%", false) end
    ),
    awful.key({ }, "XF86AudioLowerVolume",
        function () awful.util.spawn("pactl -- set-sink-volume 1 -5%", false) end
    ),
    awful.key({"Shift"}, "XF86AudioRaiseVolume",
        function () awful.util.spawn("pactl -- set-sink-volume 1 +1%", false) end
    ),
    awful.key({"Shift"}, "XF86AudioLowerVolume",
        function () awful.util.spawn("pactl -- set-sink-volume 1 -1%", false) end
    ),
    awful.key({ }, "XF86AudioMute",
        function () awful.util.spawn("amixer -D default sset Master toggle", false) end
    ),
    awful.key({ }, "XF86AudioMicMute",
        function () awful.util.spawn("amixer -D default sset Capture toggle", false) end
    ),
    awful.key({"Mod1"}, "z",
        function () awful.util.spawn("playerctl previous", false) end
    ),
    awful.key({"Mod1"}, "x",
        function () awful.util.spawn("playerctl stop", false) end
    ),
    awful.key({"Mod1"}, "c",
        function () awful.util.spawn("playerctl play-pause", false) end
    ),
    awful.key({"Mod1"}, "v",
        function () awful.util.spawn("playerctl next", false) end
    ),

    -- multi-display keys
    awful.key({modkey}, "o", awful.client.movetoscreen)
)

return M
