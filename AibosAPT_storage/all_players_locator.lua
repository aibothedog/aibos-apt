local detector = peripheral.find("playerDetector")
local playersOnline = detector.getOnlinePlayers()
term.clear()
function locate_players_online()
    term.clear()
    local playersOnline = detector.getOnlinePlayers()
    for i=1,#playersOnline do
        local playerPos = detector.getPlayerPos(playersOnline[i])
        if i == 1 then
            term.setCursorPos(1,1)
            term.write(playersOnline[i])
            term.setCursorPos(1,2)
            term.write("X: ".. playerPos.x.." Y: "..playerPos.y.." Z: " .. playerPos.z)
        elseif i == 2 then
            term.setCursorPos(1,i+1)
            term.write(playersOnline[i])
            term.setCursorPos(1,i+2)
            term.write("X: ".. playerPos.x.." Y: "..playerPos.y.." Z: " .. playerPos.z)
        else
            term.setCursorPos(1,i+2)
            term.write(playersOnline[i])
            term.setCursorPos(1,i+3)
            term.write("X: ".. playerPos.x.." Y: "..playerPos.y.." Z: " .. playerPos.z)
        end
    end
end

while true do
    if pcall(locate_players_online) then
    else
        print("Unable to locate player")
    sleep(0.5)
end
