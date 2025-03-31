local modem = peripheral.find("modem",rednet.open)
while true do    
    term.clear()
    term.setCursorPos(1,1)
    term.write("Bomboclad client")
    term.setCursorPos(1,2)
    term.write("1. HOUSE")
    term.setCursorPos(1,3)
    term.write("2. ME system (inactive)")
    term.setCursorPos(1,4)
    term.write("3. Jam Elevator (inactive)")
    term.setCursorPos(1,5)
    term.write("4. Garden (Inactive)")
    local event,key = os.pullEvent("char")
    if key == "1" then
        rednet.broadcast("BOMBOCLAD1")
    elseif key == "2" then
        rednet.broadcast("BOMBOCLAD2")
    elseif key == "3" then
        rednet.broadcast("BOMBOCLAD3")
    elseif key == "4" then
        rednet.broadcast("BOMBOCLAT4")
     end    
end
