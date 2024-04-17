for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

local game = game
local players = game.Players
local whitelist = {1443239610, 2750020740}

local function isPlayerWhitelisted(player)
    for _, id in ipairs(whitelist) do
        if player.UserId == id then
            return true
        end
    end
    return false
end

local function areOnlyWhitelistedPlayersInGame()
    local whitelistedPlayersPresent = 0
    local nonWhitelistedPlayersPresent = false
    for _, player in ipairs(players:GetPlayers()) do
        if isPlayerWhitelisted(player) then
            whitelistedPlayersPresent = whitelistedPlayersPresent + 1
        else
            nonWhitelistedPlayersPresent = true
        end
    end
    return whitelistedPlayersPresent == #whitelist, nonWhitelistedPlayersPresent
end

local function setWalkSpeed(speed)
    for _, player in ipairs(players:GetPlayers()) do
        if isPlayerWhitelisted(player) then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speed
                end
            end
        end
    end
end

local spawnArea = game.Workspace.SpawnArea
local defaultSpeed = 16
local whitelistedSpeed = 100

while true do
    local onlyWhitelisted, nonWhitelistedPresent = areOnlyWhitelistedPlayersInGame()
    if nonWhitelistedPresent then
        setWalkSpeed(defaultSpeed)
    elseif onlyWhitelisted then
        setWalkSpeed(whitelistedSpeed)
    end

    if onlyWhitelisted then
        local spawnPosition = Vector3.new(
            math.random(spawnArea.Position.X - spawnArea.Size.X/2, spawnArea.Position.X + spawnArea.Size.X/2),
            spawnArea.Position.Y,
            math.random(spawnArea.Position.Z - spawnArea.Size.Z/2, spawnArea.Position.Z + spawnArea.Size.Z/2)
        )

        for _, player in ipairs(players:GetPlayers()) do
            if isPlayerWhitelisted(player) then
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                humanoid:MoveTo(spawnPosition)
            end
        end
    end

    wait(1)
end
