local M = awful.util.table.join(
    -- Audio keys
    awful.key({ }, "XF86AudioRaiseVolume",
        function () awful.util.spawn("amixer -D default sset Master 5%+", false) end
    ),
    awful.key({ }, "XF86AudioLowerVolume",
        function () awful.util.spawn("amixer -D default sset Master 5%-", false) end
    ),
    awful.key({"Shift"}, "XF86AudioRaiseVolume",
        function () awful.util.spawn("amixer -D default sset Master 1%+", false) end
    ),
    awful.key({"Shift"}, "XF86AudioLowerVolume",
        function () awful.util.spawn("amixer -D default sset Master 1%-", false) end
    ),
    awful.key({ }, "XF86AudioMute",
        function () awful.util.spawn("amixer -D default sset Master toggle", false) end
    ),
    awful.key({ }, "XF86AudioMicMute",
        function () awful.util.spawn("amixer -D default sset Capture toggle", false) end
    )
)

return M
