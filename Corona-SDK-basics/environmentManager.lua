local environmentManager = {}
local obstacleMaker = require("obstacle")

local xPositionsObstacle = { 100, 300, 500 , 600} -- different xPositions for different type of obstacles
-- different spawning patterns for different type of obstacles
local pattern1 = {}
local pattern2 = {}
local pattern3 = {}
-- distanceToNextObstacle defines after what distance the next obstacle will spawn
pattern1[1] = {type = "bike", x = xPositionsObstacle[1], distanceToNextObstacle = 200} 
pattern1[2] = {type = "bus", x = xPositionsObstacle[2], distanceToNextObstacle =  500}
pattern1[3] = {type = "car", x = xPositionsObstacle[3], distanceToNextObstacle =  300}
pattern2[1] = {type = "bike", x = xPositionsObstacle[3], distanceToNextObstacle = 500}
pattern2[2] = {type = "bus", x = xPositionsObstacle[4], distanceToNextObstacle =  300}
pattern2[3] = {type = "car", x = xPositionsObstacle[2], distanceToNextObstacle =  200}
pattern3[1] = {type = "bike", x = xPositionsObstacle[4], distanceToNextObstacle = 100}
pattern3[2] = {type = "bus", x = xPositionsObstacle[3], distanceToNextObstacle =  100}
pattern3[3] = {type = "car", x = xPositionsObstacle[1], distanceToNextObstacle =  100}
  

local cycler -- iterates b/w 1 to #patter*
local distance, distanceLimit -- distanceLimit will contain distanceToNextObstacle of current type of obstacle
local playerVY -- player's velocity passed from gw

-- function to handle obstacle's updation
-- called from external script
function environmentManager.manageObstacles( dt, obstacles, playerVY )
	
	distance = distance + playerVY * dt -- 
			
	if distance >=  distanceLimit then
		obstacles[#obstacles+1] = obstacleMaker.new(pattern1[cycler].type,pattern1[cycler].x,100)

		distance = 0 -- reset 
		distanceLimit = pattern1[cycler].distanceToNextObstacle -- storing distance so that we can 
		
		cycler = cycler + 1 -- to spawn a different type next iteration
		if cycler > #pattern1 then-- resetting cycler to 1 if it exceedes the length of obstacles queue
			cycler = 1
		end

	end
	
	
	-- updating obstacles
	for i=1,#obstacles do
		obstacles[i]:update(playerVY, dt)
		-- if there is an element in the queue then distance should increase to compare with distance to next obstacle 
	end

	-- removing obstacles
	for i=#obstacles,1,-1 do
		if obstacles[i].outOfBound == true then
			obstacles[i]:destroyImages()
			local temp = table.remove(obstacles, i)
			temp = nil
		end
	end
end

-- called from external script
function environmentManager.init(obstaclesGroup, shadowGroup, vy  )
	obstacleMaker.displayGroup = obstaclesGroup
	obstacleMaker.shadowGroup = shadowGroup
	cycler = 1
	playerVY = vy
	distance = 0
	distanceLimit = 0
end


return environmentManager