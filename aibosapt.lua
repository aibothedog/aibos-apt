local appname = "aibosapt"
local act_install = "install"
local act_update = "update"s
local applist = "https://raw.githubusercontent.com/aibothedog/aibos-apt/refs/heads/main/AibosAPT.json"
local list = nil
function fetchRegistry()
    if list then
        return
    end
    if not http.checkURL(applist) then
        error("Could not connect to the script registry.\nThe URL may not be whitelisted on this Minecraft server: " .. applist)
        return
    end
    local resp = http.get(applist)
    if not resp then
        error("Failed to fetch the script registry.")
        return
    elseif resp.getResponseCode() ~= 200 then
        error("Failed to fetch the script registry. Response code: " .. resp.getResponseCode())
        return
    end
    list = textutils.unserializeJSON(resp.readAll())
    resp.close()
    if not list then
        error("Failed to parse the Aibo's APT.")
    else
        print("Fetched the Aibo's APT.")
    end
end
function tabulateRegistry()
    fetchRegistry()
    local displayStr = ""
    for scriptName, scriptData in pairs(list["progs"]) do
        displayStr = (displayStr .. "\n[" .. scriptName .. "]\n" .. scriptData["desc"] .. "\n")
    end
    print("\nAvailable scripts:")
    textutils.pagedPrint(displayStr, 5)
end
function isScriptInRegistry(scriptName)
    fetchRegistry()
    if not list["progs"][scriptName] then
        return false
    end

    return true
end
function installScript(scriptName)
    if not isScriptInRegistry(scriptName) then
        print("Script not found in the Aibo's APT: " .. scriptName)
        print("Try running '" .. appname .. " " .. ACTION_LIST .. "' to see all available scripts and their function.")
        return
    end
    local scriptUrl = list["progs"][scriptName]["url"]
    local resp = http.get(scriptUrl)
    if not resp then
        print("Failed to fetch " .. scriptName .. ".")
        return
    elseif resp.getResponseCode() ~= 200 then
        print("Failed to fetch " .. scriptName .. ". Response code: " .. resp.getResponseCode())
        return
    end
    local scriptFile = fs.open(scriptName, "w")
    scriptFile.write(resp.readAll())
    scriptFile.close()
    resp.close()
    print("Installed " .. scriptName .. ".")
end
function updateScript(scriptName)
    if not isScriptInRegistry(scriptName) then
        print("Script not found in the Aibo's APT: " .. scriptName)
        print("Try running '" .. appname .. " " .. ACTION_LIST .. "' to see all available scripts and their function.")
        return
    end
    if not fs.exists(scriptName) then
        print(scriptName .. "is not installed.")
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
        -- print("  " .. ACTION_UPGRADE .. " - Upgrade SGet to the latest version")
        print("  " .. ACTION_LIST .. " - List all available scripts")
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
    elseif action == ACTION_LIST then
        tabulateRegistry()
    else
        print("Invalid action:", action)
    end
end
local args = {...}
local action = args[1]
handleCli(action, select(2, ...))
