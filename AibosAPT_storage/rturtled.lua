local modem_block = peripheral.find("modem", rednet.open)
local id, message
local access = nil
local id_required = nil
function split(str, delimiter)
    local result = {}
    for part in string.gmatch(str, "([^"..delimiter.."]+)") do
        table.insert(result, part)
    end
    return result
end
while not access do
    print("Enter access level (0 - restricted to a trusted ID, 1 - public): ")
    local input = io.read()   
    local inputaccess = tonumber(input)
    if not inputaccess then
        printError("Provide a valid access level (ERR: NaN)")
    else
        if inputaccess == 0 then
            access = "restricted"
            while not id_required do
                print("Enter trusted ID: ")
                local input = io.read()   
                local inputid = tonumber(input)
                if not inputid then
                    printError("Provide a valid ID (ERR: NaN)")
                else
                    id_required = inputid
                end
            end
        elseif inputaccess == 1 then
            access = "public"
        end
    end
end


print("rturtled, Access:", access)
while true do
    id, message = rednet.receive()
    if access == "restricted" then
        if id == id_required then
            if message == "FORWARD" then
                turtle.forward()
                print("Going forward, requested from PC ID: ", id)
            elseif message == "BACK" then
                turtle.back()
                print("Going backward, requested from PC ID: ", id)
            elseif message == "LEFT" then
                turtle.turnLeft()
                print("Rotating left, requested from PC ID: ", id)
            elseif message == "RIGHT" then
                turtle.turnRight()
                print("Rotating right, requested from PC ID: ", id)
            elseif message == "DOWN" then
                turtle.down()
                print("Going down, requested from PC ID: ", id)
            elseif message == "UP" then
                turtle.up()
                print("Going up, requested from PC ID: ", id)
            elseif message == "DIG" then
                turtle.dig()
                print("Diging forward, requested from PC ID: ", id)
            elseif message == "DIG_UP" then
                turtle.digUp()
                print("Diging up, requested from PC ID: ", id)
            elseif message == "DIG_DOWN" then
                turtle.digDown()
                print("Diging down, requested from PC ID: ", id)
            elseif message == "REFUEL" then
                turtle.refuel(100)
                print("Refueled, requested from PC ID: ", id)
            elseif message == "ATTACK" then
                turtle.attack()
                print("Attacked, requested from PC ID: ", id)
            elseif message == "DESTROY_AND_MOVE" then
                if turtle.detect() == true then 
                    turtle.dig()
                    turtle.forward()
                    print("Destroyed obstacle and moved forward, requested from PC ID: ", id)
                else
                    turtle.forward()
                end
            elseif message == "PLACE" then
                turtle.place()
                print("Placed forward, requested from PC ID: ", id)
            elseif message == "PLACE_UP" then
                turtle.placeUp()
                print("Placed up, requested from PC ID: ", id)
            elseif message == "PLACE_DOWN" then
                turtle.placeDown()
                print("Placed down, requested from PC ID: ", id)
            elseif message == "UP_SLOT" then
                local selected_slot = turtle.getSelectedSlot()
                if selected_slot == 16 then
                    print("Unable to change slot, reached maximum index, requested by: ", id)
                else
                    select_slot = selected_slot + 1
                    selected_slot = select_slot
                    turtle.select(select_slot)
                    print("Increased slot by 1, requested by: ", id)
                end
            elseif message == "DOWN_SLOT" then
                local selected_slot = turtle.getSelectedSlot()
                if selected_slot == 1 then
                    print("Unable to change slot, reached minimum index, requested by: ", id)
                else
                    select_slot = selected_slot - 1
                    selected_slot = select_slot
                    turtle.select(select_slot)
                    print("Decreased slot by 1, requested by: ", id)
                end
            elseif message == "PING" then
                print("Got ping from ", id)
                rednet.send(id_required, "PONG")
            elseif message == "PICK_UP" then
                turtle.suck(64)
                turtle.suckUp(64)
                turtle.suckDown(64)
                print("Picked up items, requested from PC ID: ", id)
            elseif message == "REQUEST_ITEM" then
                local selected_slot = turtle.getSelectedSlot()
                local sel_item = turtle.getItemDetail(selected_slot, false)
                if sel_item then
                    print("Requested item by computer: ", id)
                    local item = split(sel_item.name, ":")
                    rednet.send(id_required, item[2])
                else
                    rednet.send(id_required, "-")
                    print("No item in slot " .. selected_slot .. ", requested by computer: ", id)
                end
            elseif message == "REQUEST_SLOT" then
                local slot = turtle.getSelectedSlot()
                if slot then
                    rednet.send(id_required, tostring(slot))
                end
            elseif message == "REQUEST_COUNT" then
                local selected_slot = turtle.getSelectedSlot()
                local sel_item = turtle.getItemDetail(selected_slot, false)
                if sel_item then
                    print("Requested item count by computer: ", id)
                    print(sel_item.count)
                    rednet.send(id_required, sel_item.count)
                else
                    rednet.send(id_required, "-")
                    print("No item in slot " .. selected_slot .. " to count, requested by computer: ", id)
                end
            elseif message == "REQUEST_FUEL" then
                local fuel = turtle.getFuelLevel()
                if fuel then
                    print("Requested fuel level count by computer: ", id)
                    print(fuel)
                    rednet.send(id_required, fuel)
                end
            end
        else 
            print("Set in restricted mode, rejecting packet from ", id)
        end
    else
        if message == "FORWARD" then
            turtle.forward()
            print("Going forward, requested from PC ID: ", id)
        elseif message == "BACK" then
            turtle.back()
            print("Going backward, requested from PC ID: ", id)
        elseif message == "LEFT" then
            turtle.turnLeft()
            print("Rotating left, requested from PC ID: ", id)
        elseif message == "RIGHT" then
            turtle.turnRight()
            print("Rotating right, requested from PC ID: ", id)
        elseif message == "DOWN" then
            turtle.down()
            print("Going down, requested from PC ID: ", id)
        elseif message == "UP" then
            turtle.up()
            print("Going up, requested from PC ID: ", id)
        elseif message == "DIG" then
            turtle.dig()
            print("Diging forward, requested from PC ID: ", id)
        elseif message == "DIG_UP" then
            turtle.digUp()
            print("Diging up, requested from PC ID: ", id)
        elseif message == "DIG_DOWN" then
            turtle.digDown()
            print("Diging down, requested from PC ID: ", id)
        elseif message == "REFUEL" then
            turtle.refuel(100)
            print("Refueled, requested from PC ID: ", id)
        elseif message == "ATTACK" then
            turtle.attack()
            print("Attacked, requested from PC ID: ", id)
        elseif message == "DESTROY_AND_MOVE" then
            if turtle.detect() == true then 
                turtle.dig()
                turtle.forward()
                print("Destroyed obstacle and moved forward, requested from PC ID: ", id)
            else
                turtle.forward()
            end
        elseif message == "PLACE" then
            turtle.place()
            print("Placed forward, requested from PC ID: ", id)
        elseif message == "PLACE_UP" then
            turtle.placeUp()
            print("Placed up, requested from PC ID: ", id)
        elseif message == "PLACE_DOWN" then
            turtle.placeDown()
            print("Placed down, requested from PC ID: ", id)
        elseif message == "UP_SLOT" then
            local selected_slot = turtle.getSelectedSlot()
            if selected_slot == 16 then
                print("Unable to change slot, reached maximum index, requested by: ", id)
            else
                select_slot = selected_slot + 1
                selected_slot = select_slot
                turtle.select(select_slot)
                print("Increased slot by 1, requested by: ", id)
            end
        elseif message == "DOWN_SLOT" then
            local selected_slot = turtle.getSelectedSlot()
            if selected_slot == 1 then
                print("Unable to change slot, reached minimum index, requested by: ", id)
            else
                select_slot = selected_slot - 1
                selected_slot = select_slot
                turtle.select(select_slot)
                print("Decreased slot by 1, requested by: ", id)
            end
        elseif message == "REQUEST_FUEL" then
            local fuel = turtle.getFuelLevel()
            if fuel then
                print("Requested fuel level count by computer: ", id)
                print(fuel)
                rednet.send(id, fuel)
            end
        elseif message == "REQUEST_SLOT" then
            local slot = turtle.getSelectedSlot()
            if slot then
                rednet.send(id, tostring(slot))
            end
        elseif message == "PICK_UP" then
            turtle.suck(64)
            turtle.suckUp(64)
            turtle.suckDown(64)
            print("Picked up items, requested from PC ID: ", id)
        elseif message == "PING" then
            print("Got ping from " .. id .. "!")
            rednet.send(id, "PONG")
        elseif message == "REQUEST_ITEM" then
                local selected_slot = turtle.getSelectedSlot()
                local sel_item = turtle.getItemDetail(selected_slot, false)
                if sel_item then
                    print("Requested item by computer: ", id)
                    local item = split(sel_item.name, ":")
                    rednet.send(id, item[2])
                else
                    rednet.send(id, "-")
                    print("No item in slot " .. selected_slot .. ", requested by computer: ", id)
                end
        elseif message == "REQUEST_COUNT" then
            local selected_slot = turtle.getSelectedSlot()
            local sel_item = turtle.getItemDetail(selected_slot, false)
            if sel_item then
                print("Requested item count by computer: ", id)
                print(sel_item.count)
                rednet.send(id, sel_item.count)
            else
                rednet.send(id, "-")
                print("No item in slot " .. selected_slot .. " to count, requested by computer: ", id)
            end
        end
    end
end