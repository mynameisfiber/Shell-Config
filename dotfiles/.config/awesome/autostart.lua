function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("wicd-client -t")
run_once("syndaemon -i 1 -K")
run_once("gpg-agent --daemon")
run_once("dualtidy")
run_once("fluxgui")
