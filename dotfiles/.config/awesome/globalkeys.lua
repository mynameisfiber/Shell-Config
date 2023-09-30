local awful = require("awful")
local naughty = require("naughty")
local lain = require("lain")

local clock = os.clock
local naughtyvolumeid = nil
local naughtybrightid = nil
local naughtyrotateid = nil


function sleep(n)  -- seconds
   local t0 = clock()
   while clock() - t0 <= n do
   end
end

function lockscreen()
    awful.spawn("sync")
    awful.spawn("xautolock -enable")
    awful.spawn("xautolock -locknow")
end

function lockscreen_sleep()
    lockscreen()
    sleep(5)
    awful.spawn("systemctl suspend")
end

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

function change_screen_zoom(how)
    local command = "screen-zoom " .. how
    awful.spawn.easy_async_with_shell(
        command,
        function(stdout, stderr, reason, exit_code)
            naughtyzoomid = naughty.notify({
                text = stdout:gsub("^%s*(.-)%s*$", "%1"),
                title = "Screen Zoom",
                replaces_id = naughtyzoomid
            }).id
        end
    )
end

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

function rotate_screen(identifier, how)
    local command = 'xrandr --output "' .. identifier .. '" --rotate ' .. how
    awful.spawn.easy_async_with_shell(
        command,
        function(stdout, stderr, reason, exit_code)
            naughtyrotateid = naughty.notify({
                text = "Rotated screen " .. identifier .. " to: " .. how,
                title = "Screen Rotation",
                replaces_id = naughtyrotateid
            }).id
        end
    )
end

local qzeal = lain.util.quake({
    app = 'zeal',
    height = 0.5,
    followtag = true,
    vert = 'top',
})

function run_typr(params)
    local typrnotification = nil
    local typrpid = awful.spawn.easy_async_with_shell(
        "typr --debug " .. params,
        function(stdout, stderr, reason, exit_code)
            typrnotification.die(naughty.notificationClosedReason.dismissedByUser)
        end
    )
    typrnotification = naughty.notify({
        title = "typr is running",
        text = "careful... microphone is listening",
        timeout = 0,
        ignore_suspend = true,
        bg = "#FF0000",
        run = function(n)
            awful.spawn("kill " .. typrpid)
            n.die(naughty.notificationClosedReason.dismissedByUser)
        end
    })
end

function create_typr_menu()
    local typeitems = {
        { "type general",  function() run_typr("type") end },
        { "type english",  function() run_typr("--model base.en type") end },
        { "type french",  function() run_typr("--model base --language french type") end },
    }
    local copyitems = {
        { "copy general",  function() run_typr("copy") end },
        { "copy english",  function() run_typr("--model base.en copy") end },
        { "copy french",  function() run_typr("--model base --language french copy") end },
    }
    local menu = awful.menu({ items = { 
        { "type",  typeitems },
        { "copy",  copyitems},
    }})
    return menu
end

function make_global_keys(modkey)
    local typrmenu = create_typr_menu()
    local globalkeys = awful.util.table.join(
        -- typr
        awful.key({ modkey}, "`",
            function () typrmenu:toggle() end
        ),

        -- Quakes
        awful.key({ modkey}, "z",
            function () qzeal:toggle() end
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
        awful.key({ modkey }, "F6",
            function() change_brightness("+5%") end
        ),
        awful.key({ modkey }, "F5",
            function() change_brightness("-5%") end
        ),
        awful.key({ modkey, "Shift"}, "F6",
            function() change_brightness("+1%") end
        ),
        awful.key({ modkey, "Shift"}, "F5",
            function() change_brightness("-1%") end
        ),

        -- screen zoom
        awful.key({ "Control", modkey }, "=",
            function() change_screen_zoom("0.1") end
        ),
        awful.key({ "Control", modkey }, "-",
            function() change_screen_zoom("-0.1") end
        ),
        awful.key({ "Control", modkey, "Shift" }, "=",
            function() change_screen_zoom("0.05") end
        ),
        awful.key({ "Control", modkey, "Shift" }, "-",
            function() change_screen_zoom("-0.05") end
        ),
        awful.key({ "Control", modkey }, "0",
            function() change_screen_zoom("reset") end
        ),
    
        -- Lock
    	awful.key({ }, "XF86Lock", lockscreen),
    	awful.key({ modkey }, "F10", lockscreen),
    	awful.key({ "Control", modkey }, "F10", lockscreen_sleep),
    	awful.key({ "Control", }, "XF86Lock", lockscreen_sleep),
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
        ),

        -- Screen Rotation
        awful.key({ modkey, "Control"}, "Left",
            function()
                local screen = awful.screen.focused()
                for output in pairs(screen.outputs) do
                    rotate_screen(output, 'left')
                end
            end
        ),
        awful.key({ modkey, "Control"}, "Right",
            function()
                local screen = awful.screen.focused()
                for output in pairs(screen.outputs) do
                    rotate_screen(output, 'right')
                end
            end
        ),
        awful.key({ modkey, "Control"}, "Up",
            function()
                local screen = awful.screen.focused()
                for output in pairs(screen.outputs) do
                    rotate_screen(output, 'normal')
                end
            end
        ),
        awful.key({ modkey, "Control"}, "Down",
            function()
                local screen = awful.screen.focused()
                for output in pairs(screen.outputs) do
                    rotate_screen(output, 'inverted')
                end
            end
        )
    )
    
    return globalkeys
end

return make_global_keys
