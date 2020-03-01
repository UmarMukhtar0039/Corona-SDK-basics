local obstacleTypesMap = {}

function obstacleTypesMap.makeObstacle( obstacle, displayGroup )
    if obstacle.type == "car" then
        obstacle.width = 100
        obstacle.height = 150
        obstacle.sprite = display.newImage(displayGroup, "car.png", obstacle.x, obstacle.y)
        obstacle.sprite.x = obstacle.x
        obstacle.sprite.y = obstacle.y
        -- collision bounds
        obstacle.contentBound.width = obstacle.width - 20
        obstacle.contentBound.height = obstacle.height - 20
		obstacle.contentBound.xMin = obstacle.x - obstacle.contentBound.width * 0.5
		obstacle.contentBound.xMax = obstacle.x + obstacle.contentBound.width * 0.5
		obstacle.contentBound.yMin = obstacle.y - obstacle.contentBound.height * 0.5
		obstacle.contentBound.yMax = obstacle.y + obstacle.contentBound.height * 0.5
        -- obstacle.contentBound.x = obstacle.x
        -- obstacle.contentBound.y = obstacle.y
        -- obstacle.contentBound.radius = obstacle.height * 0.5
    ---------------------------
    
    elseif obstacle.type == "bus" then
        obstacle.width = 100
        obstacle.height = 248
        obstacle.sprite = display.newImage(displayGroup, "bus1.png", obstacle.x, obstacle.y)
        obstacle.sprite.x = obstacle.x
        obstacle.sprite.y = obstacle.y
        -- collision bounds
        obstacle.contentBound.width = obstacle.width - 20
        obstacle.contentBound.height = obstacle.height - 20
        obstacle.contentBound.xMin = obstacle.x - obstacle.contentBound.width * 0.5
        obstacle.contentBound.xMax = obstacle.x + obstacle.contentBound.width * 0.5
        obstacle.contentBound.yMin = obstacle.y - obstacle.contentBound.height * 0.5
        obstacle.contentBound.yMax = obstacle.y + obstacle.contentBound.height * 0.5
        -- obstacle.contentBound.x = obstacle.x
        -- obstacle.contentBound.y = obstacle.y
        -- obstacle.contentBound.radius = obstacle.height * 0.5
    ---------------------------
    
    elseif obstacle.type == "bike" then
        obstacle.width = 100
        obstacle.height = 150
        obstacle.sprite = display.newImage(displayGroup, "bike1.png", obstacle.x, obstacle.y)
        obstacle.sprite.x = obstacle.x
        obstacle.sprite.y = obstacle.y
        -- collision bounds
        obstacle.contentBound.width = obstacle.width - 20
        obstacle.contentBound.height = obstacle.height - 20
        obstacle.contentBound.xMin = obstacle.x - obstacle.contentBound.width * 0.5
        obstacle.contentBound.xMax = obstacle.x + obstacle.contentBound.width * 0.5
        obstacle.contentBound.yMin = obstacle.y - obstacle.contentBound.height * 0.5
        obstacle.contentBound.yMax = obstacle.y + obstacle.contentBound.height * 0.5
        -- obstacle.contentBound.x = obstacle.x
        -- obstacle.contentBound.y = obstacle.y
        -- obstacle.contentBound.radius = obstacle.height * 0.5
    end

    return obstacle
end

return obstacleTypesMap