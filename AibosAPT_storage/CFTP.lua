-- CFTP Protocol (send/receive)

local modem = peripheral.find("modem", rednet.open)
if modem then
    continue()
end
--local modem_side = peripheral.getName(modem)
local protocol = "CFTP"

local args = {...}
if #args < 1 then
  print("Usage:")
  print( arg[0],"send <filePath>")
  print(  arg[0], "receive")
  return
end

if args[1] == "receive" then
  -- Recieve mode
  write("Hostname = ")
  local hostname = read()
  rednet.host(protocol, hostname)

  local file = nil
  local sender = nil

  print("Awaiting file transfer...")
  while true do
   local senderID, msg = rednet.receive(protocol)

   if type(msg) == "table" then
    if msg.type == "start" and msg.to == hostname then
      print("Recieving file: " .. (msg.name or "[no name]"))
      file = fs.open(msg.name, "w")
      sender = senderID

    elseif msg.type == "chunk" and file and senderID == sender then
      file.write(msg.content)

    elseif msg.type == "end" and file and senderID == sender then
      file.close()
      print("File received")
      file = nil
      sender = nil
    end
  end
  end

elseif args[1] == "send" and #args >= 2 then
  -- Send mode
  write("Hostname = ")
  local hostname = read()
  local filePath = args[2]

  local hostnameID = rednet.lookup(protocol, hostname)
  if not hostnameID then
    printError("Hostname not found")
    return
  end

  if not fs.exists(filePath) then
    printError("File not found")
    return
  end

  local file = fs.open(filePath, "r")
  local filename = fs.getName(filePath)

  -- Send header
  rednet.send(hostnameID, {type="start", name=filename, to=hostname}, protocol)

  while true do
    local chunk = file.read(8192)
    if not chunk then break end
    rednet.send(hostnameID, {type="chunk", content=chunk}, protocol)
  end

  file.close()
  rednet.send(hostnameID, {type="end"}, protocol)
  print("File sent")

else
  printError("Incorrect arguments!")
end
