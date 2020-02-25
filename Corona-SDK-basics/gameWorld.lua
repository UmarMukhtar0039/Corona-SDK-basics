local gameWorld = {}
local deltaTime = require("deltaTime")
local playerMaker = require("player")
local collisionHandler = require("collisionHandler")
local animationService = require("animationService")
local inGameUI = require("inGameUI")
local toast = require("toast")
local environmentManager = require("environmentManager")

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

local tab = { "one", "two ", "three"}
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
	if gameWorld.gameState == "suspended" or gameWorld.gameState == "gameOver" then
		animationService.pause()
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
		if collisionHandler.rectangleRectangleCollision( player, obstacles[i] ) then
			-- if collision occurs player's debug sprite will turn red
			color = { r = 1, g = 0, b = 0}
			gameWorld.gameState = "gameOver"
			animationService.pause()
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
	environmentManager.manageObstacles(dt, obstacles, player.vy)
end

-------------------------

local function onKeyEvent( event )
	if (event.phase == "down") then
		if (event.keyName == "d") then -- when 'd' key is pressed, set player's direction to right
			player.dir = "r"
		elseif(event.keyName == "a") then -- when 'a' key is pressed, set player's direction to left
			player.dir = "l"
		end
		if (event.keyName == "q" and gameWorld.gameState ~= "gameOver") then
			gameWorld.gameState = "suspended"	
			inGameUI.makePauseMenu(inGameUIGroup) -- shouldn't use it here
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
	toast.displayGroup = inGameUIGroup
	toast.showToast("umar")
	toast.showToast(" Mukhtar")
	toast.showToast(" dddd")
	toast.showToast(" aaa")

	readyText = display.newText(obstaclesGroup, "Tap To play", display.contentCenterX, display.contentCenterY)
	-- assinging player group to the table player at key displayGroup
	playerMaker.displayGroup = playerGroup
	playerMaker.shadowGroup = shadowGroup
	player = playerMaker.new("tiger", display.contentWidth * 0.5, display.contentHeight - 139 * 0.5 - 70)
	
	-- setting up background
	background1 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, display.contentCenterY )
	background2 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, -1334*0.5)
	
	obstacles = {}
	
	-- inGameUI.displayGroup = inGameUIGroup
	inGameUI.init(gameWorld)

	environmentManager.init(obstaclesGroup, shadowGroup, player.vy)
end

init()


------------------------

Runtime:addEventListener("key", onKeyEvent)
Runtime:addEventListener("tap", onTap)
Runtime:addEventListener("enterFrame", update)

return gameWorld