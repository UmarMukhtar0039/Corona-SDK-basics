local gameWorld = {}
local deltaTime = require("deltaTime")
local playerMaker = require("player")
local collisionHandler = require("collisionHandler")
local animationService = require("animationService")
local inGameUI = require("inGameUI")
local toast = require("toast")
local environmentManager = require("environmentManager")
local gameplayManager = require("gameplayManager")
local particleSystem = require("particleSystem")


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
local leftButton -- properties table for touching the left side of screen
local rightButton -- properties table for touching the right side of screen
local huntButton -- hunt button

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
	gameplayManager.update(dt)
	animationService.resume() -- resumes the animations of all objects
	
	updatePlayer(dt)	
	particleSystem.update(player.x, player.y, player.vy, dt)
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
	background1.y = background1.y - player.vy * dt
	background2.y = background2.y - player.vy * dt
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

	-- updating obstacles
	for i=1,#obstacles do
		obstacles[i]:update(player.vy, dt)
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

-------------------------

local function onKeyEvent( event )
	if (event.phase == "down") then
		if event.keyName == "h" and gameWorld.gameState ~= "suspended" then -- start hunting if h key is pressed
 			if player.isHunting == false then
				player:hunt()
			end		
		end

		if (event.keyName == "q" and gameWorld.gameState ~= "gameOver") then
			gameWorld.gameState = "suspended"	
			inGameUI.makePauseMenu(inGameUIGroup) -- shouldn't use it here
		end
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

-- Runtime event listener for touch
local function onTouch( event )
	
	if (event.phase == "began") then
		if collisionHandler.rectPoint(leftButton, event) then -- when left side of screen is touched, set player's direction to left
			leftButton.image:setFillColor(1,1,1, 2) -- setting alpha twice the value when touched
			if (rightButton.image.alpha > 0.5) then
				rightButton.image:setFillColor(1,1,1,0.5) -- fade right button
			end
			player.dir = "l"
		elseif collisionHandler.rectPoint(rightButton, event) then -- when right side of screen is touched, set player's direction to right
			player.dir = "r"
			rightButton.image:setFillColor(1,1,1, 2) -- setting alpha twice the value when touched
			if (leftButton.image.alpha > 0.5) then
				leftButton.image:setFillColor(1,1,1, 0.5) -- fade left button
			end
		elseif collisionHandler.rectPoint(huntButton, event) and gameWorld.gameState ~= "suspended" then -- touch is on hunt
			if player.isHunting == false then
				player:hunt()
				huntButton.image:setFillColor(1,1,1,2) -- highlight hunt button
			end
		else
			player.dir = nil
			if leftButton.image.alpha > 0.5 then
				leftButton.image:setFillColor(1,1,1,0.5)
			end
			if rightButton.image.alpha > 0.5 then
				rightButton.image:setFillColor(1,1,1,0.5)
			end
		end
	end
	---------------------

	-- touch and move
	if (event.phase == "moved") then -- if touch is moved to a different area change direction of player accordingly
		if collisionHandler.rectPoint(leftButton, event) then -- event will have the x,y co-ordinate of touch
			player.dir = "l" -- move left
			leftButton.image:setFillColor(1,1,1, 2) -- setting alpha twice the value when touched
			if (rightButton.image.alpha > 0.5) then
				rightButton.image:setFillColor(1,1,1, 0.5)
			end
		elseif collisionHandler.rectPoint(rightButton, event) then -- move right
			player.dir = "r"
			rightButton.image:setFillColor(1,1,1, 2) -- setting alpha twice the value when touched
			if (leftButton.image.alpha > 0.5) then
				leftButton.image:setFillColor(1,1,1, 0.5)
			end
		else -- if touch event is outside the contentBounds of both buttons
			if leftButton.image.alpha > 0.5 then
				leftButton.image:setFillColor(1,1,1,0.5)
			end
			if rightButton.image.alpha > 0.5 then
				rightButton.image:setFillColor(1,1,1,0.5)
			end 
			if huntButton.image.alpha > 0.5 then
			huntButton.image:setFillColor(1,1,1,0.5)
		end
			player.dir = nil
		end		
	end
	---------------------
	-- if touch is lifted
	if (event.phase == "ended") then 
		player.dir = nil
		if leftButton.image.alpha > 0.5 then
				leftButton.image:setFillColor(1,1,1,0.5)
		end
		if rightButton.image.alpha > 0.5 then
				rightButton.image:setFillColor(1,1,1,0.5)
		end
		if huntButton.image.alpha > 0.5 then
			huntButton.image:setFillColor(1,1,1,0.5)
		end
	end
end

-----------------------------

-- initializing touch properties which includes left/right touch to move left/right and hunt button
local function initTouch( )
	leftButton = { contentBound = {xMin = 0, yMin = height * 0.75, xMax = width * 0.5, yMax = height} }
	leftButton.image = display.newImage(inGameUIGroup,"arrow-left.png", width * 0.25, height * 0.75 + 334 * 0.5)
	leftButton.image:setFillColor(1,1,1,0.5) -- if button is not pressed then it will appear faded
	
	rightButton = { contentBound = {xMin = leftButton.contentBound.xMax, yMin = leftButton.contentBound.yMin, xMax = width, yMax = leftButton.contentBound.yMax} }
	rightButton.image = display.newImage(inGameUIGroup,"arrow-right.png", width * 0.75, height * 0.75 + 344 * 0.5)
	rightButton.image:setFillColor(1,1,1,0.5) -- if button is not pressed then it will appear faded
	
	huntButton = { contentBound = {xMin = width * 0.5 - 150 * 0.5 , yMin = height * 0.5 + 100, xMax = width * 0.5 + 150 * 0.5, yMax = height * 0.5 + 200} }
	huntButton.image = display.newRect(inGameUIGroup, width * 0.5, height * 0.5 + 150, huntButton.contentBound.xMax - huntButton.contentBound.xMin, huntButton.contentBound.yMax - huntButton.contentBound.yMin)
	huntButton.image:setFillColor(1,1,1,0.5) -- if button is not pressed then it will appear faded
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
	-- toast.showToast("umar")
	-- toast.showToast(" Mukhtar")


	readyText = display.newText(obstaclesGroup, "Tap To play", display.contentCenterX, display.contentCenterY)
	-- assinging player group to the table player at key displayGroup
	playerMaker.displayGroup = playerGroup
	playerMaker.shadowGroup = shadowGroup
	player = playerMaker.new("tiger", display.contentWidth * 0.5, display.contentHeight - 250)
	
	-- setting up background
	background1 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, display.contentCenterY )
	background2 = display.newImage(backgroundGroup, "backgroundRoad.png", display.contentCenterX, -1334*0.5)
	
	obstacles = {}
	
	-- inGameUI.displayGroup = inGameUIGroup
	inGameUI.init(gameWorld)
	-- setting up environmentManager
	environmentManager.init(obstaclesGroup, shadowGroup)
	
	-- setting up left and right touch buttons
	initTouch()

	--initializing gameplayManager
	gameplayManager.init(player)

	--initializing particle system
	particleSystem.displayGroup = shadowGroup
	particleSystem.init(player.x, player.y)
end

init()


------------------------

Runtime:addEventListener("key", onKeyEvent)
Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("tap", onTap)
Runtime:addEventListener("enterFrame", update)

return gameWorld