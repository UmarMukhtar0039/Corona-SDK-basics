-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local widthSelector = { 100, 50, 250 ,300 }
local heightSelector = { 200, 100 , 250 , 150}
local speed = 200

local moveTime = 0
local moveTimerLimit = 1
-- spawn block on tap

print "Heyafdksadjf"

local prevTime = 0
local randomW = math.random(#widthSelector)
local randomH = math.random( #heightSelector )
local object = display.newRect(display.contentWidth/2, heightSelector[randomH]/2, widthSelector[randomW], heightSelector[randomH])

function update(event)
    
    -- calculate delta time
    local deltaTime = 0
    local currentTime = system.getTimer() / 1000 -- gives in mili seconds so convert in seconds
    deltaTime = currentTime - prevTime
    prevTime = currentTime

    --moving object every frame
    moveTime = moveTime + deltaTime
    -- a little delay the first time, as we are not resetting moveTime
    if object.y ~= nil then
        if moveTime >= moveTimerLimit then
            object.y = object.y + speed * deltaTime
        end

        if object.y > display.contentHeight then
        local temp = object:removeSelf()
            temp = nil
        end
    end

end



Runtime:addEventListener("enterFrame", update)