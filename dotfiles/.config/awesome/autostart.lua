local awful = require("awful")

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("~/.config/awesome/scripts/locker.sh")
run_once("xmodmap ~/.Xmodmap")
run_once("nm-applet")
run_once("volti")
run_once("blueman-applet")
run_once("fluxgui")
