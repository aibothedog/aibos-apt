local detector = peripheral.find("playerDetector")
local playersOnline = detector.getOnlinePlayers()
term.clear()
while true do
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
    sleep(0.5)
end
