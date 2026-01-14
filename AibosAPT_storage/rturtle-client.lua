local modem = peripheral.find("modem", rednet.open)
local turtleid = nil
while not turtleid do
    print("Enter turtle ID: ")
    local input = io.read()   
    local inputid = tonumber(input)
    if not inputid then
        printError("Provide a valid ID (ERR: NaN)")
    else
        if os.computerID() == inputid then
            printError("Provide a valid ID (ERR: Enter turtle ID, not yours)")
        else
            rednet.send(inputid, "PING")
            local id, message = rednet.receive(nil, 1)
            if message then
                term.clear()
                turtleid = inputid
            else
                printError("Provide a valid ID (ERR: No PONG response)")
            end
        end
    end
end
mon_size = {term.getSize()}
while true do
    term.clear()
    term.setCursorPos(1, 1) -- The first column of line 1
    term.write("rturtle client ("..turtleid..")")
    term.setCursorPos(1, 2) -- The 20th column of line 2
    term.write("Q. Up")
    term.setCursorPos(1, 3) -- The 20th column of line 2
    term.write("E. Down")
    term.setCursorPos(1, 4) -- The 20th column of line 2
    term.write("W. Forward")
    term.setCursorPos(1, 5) -- The 20th column of line 2
    term.write("S. Backward")
    term.setCursorPos(1, 6) -- The 20th column of line 2
    term.write("Turn:")
    term.setCursorPos(7, 6) -- The 20th column of line 2
    term.write("<A")
    term.setCursorPos(11, 6) -- The 20th column of line 2
    term.write(">D")
    term.setCursorPos(1, 8) -- The 20th column of line 2
    term.write("Dig:")
    term.setCursorPos(6, 8) -- The 20th column of line 2
    term.write("F>")
    term.setCursorPos(9, 8) -- The 20th column of line 2
    term.write("G_")
    term.setCursorPos(12, 8) -- The 20th column of line 2
    term.write("H^")
    term.setCursorPos(1, 9) -- The 20th column of line 2
    term.write("C. Refuel")
    term.setCursorPos(1, 10) -- The 20th column of line 2
    term.write("V. Attack")
    term.setCursorPos(1, 11) -- The 20th column of line 2
    term.write("B. Destroy and move")
    term.setCursorPos(1, 12) -- The 20th column of line 2
    term.write("Place: ")
    term.setCursorPos(8, 12) -- The 20th column of line 2
    term.write("R>")
    term.setCursorPos(11, 12) -- The 20th column of line 2
    term.write("T_")
    term.setCursorPos(14, 12) -- The 20th column of line 2
    term.write("Y^")
    term.setCursorPos(1, 13) -- The 20th column of line 2
    term.write("Slot: ")
    term.setCursorPos(7, 13) -- The 20th column of line 2
    term.write("<Z")
    term.setCursorPos(10, 13) -- The 20th column of line 2
    term.write(">X")
    term.setCursorPos(1, 14) -- The 20th column of line 2
    term.write("P. Pick up items")
    term.setCursorPos(1, 15)
    term.write("Press any key to refresh")
    sleep(0.1)
    rednet.send(turtleid, "PING")
    local id, message = rednet.receive(nil, 1)
    if id then
        rednet.send(turtleid, "REQUEST_FUEL")
        local id, message = rednet.receive(nil, 1)
        if id then
            term.setCursorPos(1, tonumber(mon_size[2])) -- The 20th column of line 2
            term.clearLine()
            term.write("Fuel Units: "..message)
        else
            term.setCursorPos(1, tonumber(mon_size[2])) -- The 20th column of line 2
            term.clearLine()
            term.write("Fuel units: ?")
        end
            sleep(0.1)
        rednet.send(turtleid, "REQUEST_COUNT")
        local id, message = rednet.receive(nil, 1)
        if id then
            term.setCursorPos(1, tonumber(mon_size[2]-1)) -- The 20th column of line 2
            term.clearLine()
            term.write("Item count: ".. message)
        else
            term.setCursorPos(1, tonumber(mon_size[2]-1)) -- The 20th column of line 2
            term.clearLine()
            term.write("Item count: ?")
        end
        rednet.send(turtleid, "REQUEST_ITEM")
        local id, message = rednet.receive(nil, 1)
        if id then
            term.setCursorPos(1, tonumber(mon_size[2])-2)-- The 20th column of line 2
            term.clearLine()
            if message == "-" then
                term.write("Item: "..message)
            else
                term.write("I: "..message)
            end
        else
            term.setCursorPos(1, tonumber(mon_size[2])-2 )-- The 20th column of line 2
            term.clearLine()
            term.write("Item: ?")
        end
        sleep(0.1)
        rednet.send(turtleid, "REQUEST_SLOT")
        local id, message = rednet.receive(nil, 1)
        if id then
            term.setCursorPos(1, tonumber(mon_size[2]-3)) -- The 20th column of line 2
            term.clearLine()
            term.write("Slot: " ..message)
        else
            term.setCursorPos(1, tonumber(mon_size[2]-3)) -- The 20th column of line 2
            term.clearLine()
            term.write("Slot: ?")
        end
    else
        term.setBackgroundColor(colors.red)
        term.setCursorPos(1, tonumber(mon_size[2]-2)) -- The 20th column of line 2
        term.clearLine()
        term.write("!NETWORK ERROR!")
        term.setBackgroundColor(colors.black)
        term.setCursorPos(1, tonumber(mon_size[2])-1) -- The 20th column of line 2
        term.clearLine()
        term.setTextColor(colors.red)
        term.write("ERR: no PING resp.")
        term.setCursorPos(1, tonumber(mon_size[2])) -- The 20th column of line 2
        term.clearLine()
        term.write("Press any button to retry")
        term.setTextColor(colors.white)
    end
    local event, key = os.pullEvent("char")
    if key == "q" then
        rednet.send(turtleid, "UP")
        sleep(0.2)
    elseif key == "e" then
        rednet.send(turtleid, "DOWN")
        sleep(0.2)
    elseif key == "w" then
        rednet.send(turtleid, "FORWARD")
        sleep(0.2)
    elseif key == "s" then
        rednet.send(turtleid, "BACK")
        sleep(0.2)
    elseif key == "a" then
        rednet.send(turtleid, "LEFT")
        sleep(0.2)
    elseif key == "d" then
        rednet.send(turtleid, "RIGHT")
        sleep(0.2)
    elseif key == "f" then
        rednet.send(turtleid, "DIG")
        sleep(0.2)
    elseif key == "g" then
        rednet.send(turtleid, "DIG_DOWN")
        sleep(0.2)
    elseif key == "h" then
        rednet.send(turtleid, "DIG_UP")
        sleep(0.2)
    elseif key == "c" then
        rednet.send(turtleid, "REFUEL")
        sleep(0.2)
    elseif key == "v" then
        rednet.send(turtleid, "ATTACK")
        sleep(0.2)
    elseif key == "b" then
        rednet.send(turtleid, "DESTROY_AND_MOVE")
        sleep(1)
    elseif key == "r" then
        rednet.send(turtleid, "PLACE")
        sleep(0.2)
    elseif key == "t" then
        rednet.send(turtleid, "PLACE_DOWN")
        sleep(0.2)
    elseif key == "y" then
        rednet.send(turtleid, "PLACE_UP")
        sleep(0.2)
    elseif key == "z" then
        rednet.send(turtleid, "DOWN_SLOT")
        sleep(0.2)
    elseif key == "x" then
        rednet.send(turtleid, "UP_SLOT")
        sleep(0.2)
    elseif key == "p" then
        rednet.send(turtleid, "PICK_UP")
        sleep(0.5)
    end
end