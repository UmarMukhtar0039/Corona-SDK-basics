-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local widthSelector = { 100, 50, 250 ,300 }
local heightSelector = { 200, 100 , 250 , 150}
local xPosition = { 200, 400, 600}
local speed = 200
local spawnTime = 0
local spawnTimeLimit = 3
local objectsInGame = {}
local prevTime = 0

function update(event)
    
    -- calculate delta time
    local deltaTime = 0
    local currentTime = system.getTimer() / 1000 -- gives in mili seconds so convert in seconds
    deltaTime = currentTime - prevTime
    prevTime = currentTime
    
    --spawning objects after spawnTimeLimit
    spawnTime = spawnTime + deltaTime
    print (spawnTime)
    if spawnTime >= spawnTimeLimit then
        local randomW = math.random(#widthSelector)
        local randomH = math.random( #heightSelector )
        local xPositionSelector = math.random( #xPosition )
        --gives x coordinate from xPosition table and spawns at the height/2 above the screen
        local object = display.newRect(xPosition[xPositionSelector], -heightSelector[randomH]/2, widthSelector[randomW], heightSelector[randomH])
        objectsInGame[#objectsInGame+1] = object
        spawnTime = 0
    end
    
    --moving object every frame
    for i = 1, #objectsInGame do
        objectsInGame[i].y  = objectsInGame[i].y + speed * deltaTime
    end

    for i = #objectsInGame, 1, -1 do
        if objectsInGame[i].y + objectsInGame[i].height/2  > display.contentHeight then
                objectsInGame[i].y = objectsInGame[i].y + speed * deltaTime    
            local temp = table.remove( objectsInGame,i )
            temp:removeSelf()
            temp = nil
        end
    end
end

Runtime:addEventListener("enterFrame", update)