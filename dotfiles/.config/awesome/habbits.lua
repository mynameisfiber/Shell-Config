local naughty = require('naughty')
local gears = require('gears')

local habbits = {
    --[[
    voice = {
        frequency = 10 * 60,
        title = 'SWALLOW + HOLD',
        text = '**********',
        bg = '#fc03cf',
        screen = 1 ,
        position = 'top_middle',
        font = 'sans 14',
        timeout = 10,
    }
    --]]
}

local timers = {}
for key, values in pairs(habbits) do
    local timeout = values['frequency']
    timers[key] = gears.timer {
        timeout = timeout,
        call_now = false,
        autostart = true,
        callback = function()
            naughty.notify(values)
            return true
        end
    }
end

return timers
