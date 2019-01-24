local awful = require("awful")

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- disable mouse when typing
run_once("syndaemon -i 1 -d  -t -K")

-- start screen locker
run_once("~/.config/awesome/scripts/locker.sh")

-- keyboard mappings (ie: capslock->ctrl)
run_once("xmodmap ~/.Xmodmap")

-- gnome-network-manager
run_once("nm-applet")

-- volume manager
run_once("pasystray")

-- bluetooth?
run_once("blueman-applet")

-- change monitor colors at night
run_once("fluxgui")

--- compositing for transparency
--run_once("unagi")
