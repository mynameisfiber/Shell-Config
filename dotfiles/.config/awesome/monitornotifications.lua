local naughty = require('naughty')
local awful = require("awful")

local webcam_notifications = {}
local microphone_notifications = {}

local webcam_cmd = [[bash -c '
    inotifywait -q -m -e open -e close /dev/video*
']]
local microphone_cmd = [[ pactl subscribe ]]

awful.spawn.with_line_callback(webcam_cmd, {
    stdout = function(line)
        line = string.gsub(line, "[^A-Z]+$", "")
        local device, mode = line:match("([^ ]+) ([^_]+)")
        local nid = webcam_notifications[device]
        if mode == "OPEN" then
            webcam_notifications[device] = naughty.notify({
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
            webcam_notifications[device] = nil
        end
    end,
    stderr = function(line)
        naughty.notify { text = "WEBCAM LUA ERR:"..line}
    end,
})

awful.spawn.with_line_callback(microphone_cmd, {
    stdout = function(line)
        local mode, name, device = string.match(line, "Event '([^']+)' on ([^ ]+) #([0-9]+)")
        local nid = microphone_notifications[device]
        if (mode == nil or name ~= "source-output") then
            return
        elseif mode == "new" then
            microphone_notifications[device] = naughty.notify({
                text = "Something is using the mic, output #" .. device,
                title = "MIC IN USE",
                ignore_suspend = true,
                timeout = 0,
                bg = "#FF0000",
                replaces_id = nid
            }).id
        elseif mode == "remove" and nid then
            local note = naughty.getById(nid)
            note.die(naughty.notificationClosedReason.dismissedByUser)
            microphone_notifications[device] = nil
        end
    end,
    stderr = function(line)
        naughty.notify { text = "MICROPHONE LUA ERR:"..line}
    end,
})
