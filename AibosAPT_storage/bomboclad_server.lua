local modem = peripheral.find("modem", rednet.open)
print("Bomboclad server ")
while true do
     id,bomboclad_num = rednet.receive()
    if id then
        if bomboclad_num == "BOMBOCLAD1" then
            redstone.setOutput("top",true)
            sleep(0.2)
            redstone.setOutput("top",false)
            print("Bombocladed 1 by "..id )
        elseif bomboclad_num == "BOMBOCLAD2" then
            rs.setOutput("left",true)
            sleep(0.2)
            rs.setOutput("left",false)
            print("Bombocladed 2 by "..id ) 
        elseif bomboclad_num == "BOMBOCLAD3" then
            rs.setOutput("right",true)
            sleep(0.2)
            rs.setOutput("right",false)
            print("Bombocladed 3 by "..id)
        elseif bomboclad_num == "BOMBOCLAD4" then
            rs.setOutput("front",true)
            sleep(0.2)
            rs.setOutput("front", false)
            print("Bombocladed 4 by "..id)
        end
    end 
end
                
