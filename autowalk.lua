local game = game
local players = game.Players
local whitelist = {1443239610, 2750020740, 5608834923}

local function isPlayerWhitelisted(player)
    for _, id in ipairs(whitelist) do
        if player.UserId == id then
            return true
        end
    end
    return false
end

local function setWalkSpeed(speed)
    for _, player in ipairs(players:GetPlayers()) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
    end
end

local function moveWhitelistedPlayersToSpawn(spawnPosition)
    for _, player in ipairs(players:GetPlayers()) do
        if isPlayerWhitelisted(player) then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:MoveTo(spawnPosition)
                end
            end
        end
    end
end

local function areNonWhitelistedPlayersPresent()
    for _, player in ipairs(players:GetPlayers()) do
        if not isPlayerWhitelisted(player) then
            return true
        end
    end
    return false
end

local spawnArea = game.Workspace.SpawnArea
local defaultSpeed = 16
local whitelistedSpeed = 100

while true do
    if areNonWhitelistedPlayersPresent() then
        setWalkSpeed(defaultSpeed)
    else
        setWalkSpeed(whitelistedSpeed)
    end

    local spawnPosition = Vector3.new(
        math.random(spawnArea.Position.X - spawnArea.Size.X/2, spawnArea.Position.X + spawnArea.Size.X/2),
        spawnArea.Position.Y,
        math.random(spawnArea.Position.Z - spawnArea.Size.Z/2, spawnArea.Position.Z + spawnArea.Size.Z/2)
    )
    moveWhitelistedPlayersToSpawn(spawnPosition)

    wait(1)
end
