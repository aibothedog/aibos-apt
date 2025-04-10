local appname = "aibosapt"
local act_install = "install"
local act_update = "update"
local act_list = "list"
local applist = "https://github.com/aibothedog/aibos-apt/raw/refs/heads/main/AibosAPT.json"
local list = nil
function fetchAibosAPT()
    if list then
        return
    end
    if not http.checkURL(applist) then
        error("Could not connect to Aibo's APT\nThe URL may not be whitelisted on this Minecraft server: " .. applist)
        return
    end
    local resp = http.get(applist)
    if not resp then
        error("Failed to fetch Aibo's APT")
        return
    elseif resp.getResponseCode() ~= 200 then
        error("Failed to fetch Aibo's APT Response code: " .. resp.getResponseCode())
        return
    end
    list = textutils.unserializeJSON(resp.readAll())
    resp.close()
    if not list then
        error("Failed to parse Aibo's APT")
    else
        print("Fetched Aibo's APT")
    end
end
function tabulateAibosAPT()
    fetchAibosAPT()
    local displayStr = ""
    for scriptName, scriptData in pairs(list["progs"]) do
        displayStr = (displayStr .. "\n[" .. scriptName .. "]\n" .. scriptData["desc"] .. "\n")
    end
    print("\nAvailable scripts:")
    textutils.pagedPrint(displayStr, 5)
end
function isScriptInAibosAPT(scriptName)
    fetchAibosAPT()
    if not list["progs"][scriptName] then
        return false
    end

    return true
end
function installScript(scriptName)
    if not isScriptInAibosAPT(scriptName) then
        print("Script not found in Aibo's APT: " .. scriptName)
        print("Try running '" .. appname .. " " .. act_list .. "' to see all available scripts and their function")
        return
    end
    local scriptUrl = list["progs"][scriptName]["url"]
    local resp = http.get(scriptUrl)
    if not resp then
        print("Failed to fetch " .. scriptName)
        return
    elseif resp.getResponseCode() ~= 200 then
        print("Failed to fetch " .. scriptName .. ". Response code: " .. resp.getResponseCode())
        return
    end
    local scriptFile = fs.open(scriptName, "w")
    scriptFile.write(resp.readAll())
    scriptFile.close()
    resp.close()
    print("Installed " .. scriptName)
end
function updateScript(scriptName)
    if not isScriptInAibosAPT(scriptName) then
        print("Script not found in Aibo's APT: " .. scriptName)
        print("Try running '" .. appname .. " " .. act_list .. "' to see all available scripts and their function")
        return
    end
    if not fs.exists(scriptName) then
        print(scriptName .. " is not installed.")
        print("Would you like to install it? Yes/No")
        local input = read()
        if (string.lower(input) == "y") or (string.lower(input) == "yes") then
            installScript(scriptName)
        end
    else
        fs.delete(scriptName)
        installScript(scriptName)
    end
end
function handleCli(action, ...)
    if not action then
        print("Usage: " .. appname .. " <action> <scriptName>")
        print("Actions:")
        print("  " .. act_install .. " <scriptName> - Install a script")
        print("  " .. act_update .. " <scriptName> - Update a script")
        print("  " .. act_list .. " - List all available scripts")
        return
    end
    action = string.lower(action)
    local args = {...}
    if (action == act_install) or (action == act_update) then
        local scriptName = args[1]
        if not scriptName then
            print("Usage: " .. appname .. " " .. action .. " <scriptName>")
            return
        end
        if action == act_install then
            installScript(scriptName)
        elseif action == act_update then
            updateScript(scriptName)
        end
    elseif action == act_list then
        tabulateAibosAPT()
    else
        print("Invalid action:", action)
    end
end
local args = {...}
local action = args[1]
handleCli(action, select(2, ...))
