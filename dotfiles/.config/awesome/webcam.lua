local naughty = require('naughty')
local awful = require("awful")
local notifications = {}

local monitor_cmd = [[bash -c '
    inotifywait -q -m -e open -e close /dev/video*
']]

awful.spawn.with_line_callback(monitor_cmd, {
    stdout = function(line)
        line = string.gsub(line, "[^A-Z]+$", "")
        local device, mode = line:match("([^ ]+) ([^_]+)")
        local nid = notifications[device]
        if mode == "OPEN" then
            notifications[device] = naughty.notify({
                text = "Device is open: " .. device,
                title = "WEBCAM IN USE",
                ignore_suspend = true,
                timeout = 0,
                bg = "#FF0000",
                replaces_id = nid
            }).id
        elseif nid then
            local note = naughty.getById(nid)
            note.die(naughty.notificationClosedReason.dismissedByUser)
            notifications[device] = nil
        end
    end,
    stderr = function(line)
        naughty.notify { text = "WEBCAM LUA ERR:"..line}
    end,
})
