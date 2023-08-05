-- EDATA.lua
-- Tem que ser moduleScript

local EDATA = {}

function EDATA.get(element, key)
    if element and typeof(element) == "Instance" then
        local data = element:GetAttribute(key)
        return data, data ~= nil
    end
    return nil, false
end

function EDATA.set(element, key, value)
    if element and typeof(element) == "Instance" then
        element:SetAttribute(key, value)
    else
        warn("Invalid element or element type. Unable to set element data.")
    end
end

function EDATA.remove(element, key)
    if element and typeof(element) == "Instance" then
        element:SetAttribute(key, nil)
    else
        warn("Invalid element or element type. Unable to remove element data.")
    end
end

return EDATA

--[[ Exemplo: ]]
--[[ 
    local EDATA = require(game.ServerScriptService.EDATA) -- ou game.ReplicatedStorage.EDATA, dependendo de onde você criou o módulo

local player = game.Players.LocalPlayer
local part = game.Workspace.Part

-- Usando as funções
EDATA.set(player, "Coins", 100)
EDATA.set(part, "Health", 100)

local coins, hasCoins = EDATA.getElementData(player, "Coins")
local health, hasHealth = EDATA.getElementData(part, "Health")

if hasCoins then
    print("Player Coins:", coins)
else
    print("No coins data found for the player.")
end

if hasHealth then
    print("Part Health:", health)
else
    print("No health data found for the part.")
end

EDATA.remove(player, "Coins")

 ]]


 --[[ DataStore pra salvar a table de dados ]]
-- Entrypoint Script (e.g., ServerScriptService or ServerScript)

local DataStoreService = game:GetService("DataStore")
local EDATA = require(game.ServerScriptService.EDATA)

local dataStore = DataStoreService:GetDataStore("ElementDataStore") -- Defina um nome único para o DataStore

local function saveElementData(element, key, value)
    local success, error = pcall(function()
        local data = EDATA.getElementData(element, key)
        if data then
            dataStore:SetAsync(tostring(element:GetFullName()).."_"..key, value)
        end
    end)

    if not success then
        warn("Erro ao salvar os dados:", error)
    end
end

local function loadElementData(element, key)
    local success, result = pcall(function()
        return dataStore:GetAsync(tostring(element:GetFullName()).."_"..key)
    end)

    if success then
        return result
    else
        warn("Erro ao carregar os dados:", result)
        return nil
    end
end

game.Players.PlayerAdded:Connect(function(player)
    -- Carregar os dados do jogador do DataStore
    local coins = tonumber(loadElementData(player, "Coins")) or 0
    local health = tonumber(loadElementData(player, "Health")) or 100

    EDATA.setElementData(player, "Coins", coins)
    EDATA.setElementData(player, "Health", health)
end)

game.Players.PlayerRemoving:Connect(function(player)
    -- Salvar os dados do jogador no DataStore ao sair
    local coins, hasCoins = EDATA.getElementData(player, "Coins")
    local health, hasHealth = EDATA.getElementData(player, "Health")

    if hasCoins and hasHealth then
        saveElementData(player, "Coins", coins)
        saveElementData(player, "Health", health)
    end
end)
