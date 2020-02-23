local gameWorld = {}
local deltaTime = require("deltaTime")
local playerMaker = require("player")
local obstacleMaker = require("obstacle")
local collisionHandler = require("collisionHandler")
local animationService = require("animationService")
local inGameUI = require("inGameUI")

-- display groups
local masterGroup
local backgroundGroup
local shadowGroup
local playerGroup
local obstaclesGroup
local inGameUIGroup

-- objects in game
local player
local background1
local background2
local obstacles

-- spawning time
local timer
local timerLimit

-- display content properties
local height = display.contentHeight
local width = display.contentWidth

-- x position for obstacle 
local xPositionsObstacle


-- udpateFunction's fwd references
local updatePlayer
local updateBackground
local updateObstacles

local readyText 

---------------------------
-- updates the whole game
local function update( )
	local dt = deltaTime.getDelta()

	-- pause all the animations
	if gameWorld.gameState == "suspended" then
		animationService.pause()
		inGameUI.makePauseMenu() -- shouldn't use it here
		return
	end	

	if gameWorld.gameState == "ready" then
		animationService.pause()
		return	
	end	
	-- if gameState is running

	animationService.resume() -- resumes the animations of all objects
	
	updatePlayer(dt)	
	updateBackground(dt)
	updateObstacles(dt)
end


-------------------------
-- called every frame from update
function updatePlayer(dt)
	player:update(dt)

	local color = { r = 1, g = 1, b = 1}
	-- checking if player collides with obstacles or not
	for i=1,#obstacles do
		if collisionHandler.circleRectangleCollision(obstacles[i], player) then
			-- if collision occurs player's debug sprite will turn red
			color = { r = 1, g = 0, b = 0}
			gameWorld.gameState = "gameOver"
			animationService.pause()
			display.newRect(obstaclesGroup, display.contentCenterX, display.contentCenterY, width, height)
			readyText = display.newText(obstaclesGroup,"Game Over", display.contentCenterX, display.contentCenterY)
			readyText:setFillColor(0,0,0)
			return
			-- end the game

		end
	end
	if player.debugSprite ~= nil then
		player.debugSprite:setFillColor(color.r,color.g,color.b)
	end
end


-- function to handle background's updation
function updateBackground(dt)
	-- setting background's y axis according to velocity w.r.t frame time
	-- local relativeVelocity = 0 - player.vy
	background1.y = background1.y + player.vy * dt
	background2.y = background2.y + player.vy * dt
	--if background1 or background2 has gone down of screen reset it back to above the screen
	if (background1.y >= ( height + height*0.5)) then
		background1.y =  background2.y-background2.height 
	end
	if (background2.y >= (height + height * 0.5) ) then
		background2.y = background1.y-background1.height
	end
end

-------------------------

-- function to handle obstacle's updation
function updateObstacles( dt )
	timer = timer + dt
	if timer >= timerLimit then
		local selector = math.random( #xPositionsObstacle )
		obstacles[#obstacles+1] = obstacleMaker.new("car",xPositionsObstacle[selector],100)
		timer = 0
	end

	-- updating obstacles
	for i=1,#obstacles do
		obstacles[i]:update(player.vy, dt)
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

-------------------------

local function onKeyEvent( event )
	if (event.phase == "down") then
		if (event.keyName == "d") then -- when 'd' key is pressed, set player's direction to right
			player.dir = "r"
		elseif(event.keyName == "a") then -- when 'a' key is pressed, set player's direction to left
			player.dir = "l"
		end
		if (event.keyName == "q") then
			gameWorld.gameState = "suspended"	
		end
	end
	if (event.phase == "up") then
		player.dir = nil
	end
end

-----------------------------

local function onTap(event)
	if (gameWorld.gameState == "ready") then
		gameWorld.gameState = "running"
		readyText:removeSelf()
		readyText = nil	
	end
end

-----------------------------

-- initializes all objects in game
local function init()
	-- initializing all display groups
	masterGroup = display.newGroup()
	backgroundGroup = display.newGroup()
	shadowGroup = display.newGroup()
	playerGroup = display.newGroup()
	obstaclesGroup = display.newGroup()
	inGameUIGroup = display.newGroup()
	masterGroup:insert(backgroundGroup)
	masterGroup:insert(shadowGroup)
	masterGroup:insert(playerGroup)
	masterGroup:insert(obstaclesGroup)
	masterGroup:insert(inGameUIGroup)
	gameWorld.gameState = "ready" -- initially the game state will by ready

	readyText = display.newText(obstaclesGroup, "Tap To play", display.contentCenterX, display.contentCenterY)

	-- assinging player group to the table player at key displayGroup
	playerMaker.displayGroup = playerGroup
	playerMaker.shadowGroup = shadowGroup
	player = playerMaker.new("tiger", display.contentWidth * 0.5, display.contentHeight - 139 * 0.5 - 70)
	
	-- setting up background
	background1 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, display.contentCenterY )
	background2 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, -1334*0.5)
	
	-- setting up obstacles
	timer = 0
	timerLimit = 3
	xPositionsObstacle = { 100, 300, 500 , 600}
	obstacles = {}
	obstacleMaker.displayGroup = obstaclesGroup
	obstacleMaker.shadowGroup = shadowGroup
	inGameUI.displayGroup = inGameUIGroup
	inGameUI.init( gameWorld)
end

init()


------------------------

Runtime:addEventListener("key", onKeyEvent)
Runtime:addEventListener("tap", onTap)
Runtime:addEventListener("enterFrame", update)

return gameWorld