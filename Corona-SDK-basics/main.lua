
local deltaTime = require("deltaTime")
local fps = require ( "fps")
-- local shakeEffect = require("shakeEffect")
-- local slowMotionEffect = require("slowMotionEffect")

local prevTime = 0
local spawnedObstacles = { } -- table of spwaned obstacles in game 	
local spawnTimer = 0
local spawnTimeLimit = 3 -- in seconds

-- obstacle's properties
local height, width, acc

-- forward references
local updatePlayer
local updateBackground

-- this is the player we will possess in future
local player = {}

--background image`
local background1
local background2
local backgroundVY 


-- Displays Groups
local masterGroup = display.newGroup()
local backgroundGroup = display.newGroup()
local playerGroup = display.newGroup()
local obstaclesGroup = display.newGroup()
-- inserting sub display groups in master group
masterGroup:insert(backgroundGroup)
masterGroup:insert(obstaclesGroup)
masterGroup:insert(playerGroup)


-- initializing fps
fps.init()


-----------------------
function update(event)
	
	-- -- calculating delta time 
	-- local currentTime = system.getTimer() / 1000
	-- local deltaTime = currentTime - prevTime
	-- prevTime = currentTime


	local dt = deltaTime.getDelta()

	-- calculating average FPS
	fps.update(dt)
	-- shakeEffect.update(dt)
	-------------------

	-- this updates player's view and model
	updatePlayer(dt)
	-- updating background for scrolling functoinality
	updateBackground(dt)

	-- this block of code deals with spawning of obstacles 
	spawnTimer = spawnTimer + dt

	-- obstacle will be spawned after spawnTimeLimit
	if spawnTimer > spawnTimeLimit then
		-- selects a position on x axis, a random scale and color from table : xPositions, scale, color
		local selector = math.random(#xPositions)
		
		-- if xPositions == 1 then

		-- end 
		
		local obstacle = display.newImage(obstaclesGroup,"Bg1rcaR.png", xPositions[selector],-5)	
		obstacle.vy = obstacleVelocity[selector]-- this is vertical velocity of the obstacle defined in attributes table
		
		-- adding reference of obstacle in the table
		spawnedObstacles[#spawnedObstacles+1] = obstacle
		
		-- resetting the timer to 0 after spawning
		spawnTimer = 0
	end
	
	-----------------
	-- this block of code will move the obstacles in the table
	for i = 1, #spawnedObstacles do
		spawnedObstacles[i].vy = (spawnedObstacles[i].vy + backgroundVY)*0.5 + backgroundVY
		spawnedObstacles[i].vy = spawnedObstacles[i].vy + acc * dt
 		spawnedObstacles[i].y = spawnedObstacles[i].y + spawnedObstacles[i].vy * dt 
		-- print ("main speed of obstacle ".. i.. " : "..spawnedObstacles[i].vy)		
	end
	
	-----------------`

	-- removing obstacles from spawnedObstacles table as it goes out of screen``
	for i =  #spawnedObstacles, 1, -1 do  
	 	
	 	-- if obj goes beyond screen remove it from table and delete it
	 	if 	spawnedObstacles[i].y - spawnedObstacles[i].height > height then 
			local temp = table.remove(spawnedObstacles,i )
			temp:removeSelf()
			temp = nil
		end
	end
	-----------
end

------------------------

-- this function will update the player's model and view
function updatePlayer(dt)
	  -- this is part of model
 	if player.dir == "r" then
		player.x = player.x + player.vx * dt
	 	
 	elseif player.dir == "l" then
		player.x = player.x - player.vx * dt

	elseif player.dir == "u" then
		player.y = player.y - backgroundVY * dt
		
	elseif player.dir == "d" then
		player.y = player.y + backgroundVY * dt
	end


  	---- this is part the of view
	player.sprite.x = player.x
  	player.sprite.y = player.y

end

-------------------------
-- scrolling functionality
function updateBackground(dt)
	-- setting background's y axis according to velocity w.r.t frame time
	background1.y = background1.y + backgroundVY * dt
	background2.y = background2.y + backgroundVY * dt
	--if background1 or background2 has gone down of screen reset it back to above the screen
	if (background1.y >= ( height + height*0.5)) then
		background1.y = (10 + -height*0.5)
	end
	if (background2.y >= (height + height * 0.5) ) then
		background2.y = (10 + -height*0.5)
	end

end


------------------------

-- setting w,a,s,d keys for moving up,left,down,right
local function onKeyEvent( event )
	
	-- print (event.keyName) 
    if event.phase == "down" then
    	if event.keyName == "d" then 
    		player.dir = "r"
	 	
		elseif event.keyName == "a" then
	    	player.dir = "l"
	    	-- slowMotionEffect.play(1000)
		else
			player.dir = nil
		end
	end

	if event.phase == "up" then
		player.dir = nil
    end

    return false
end
 
 -- function to reset Animation
 local function spriteListener( event )
 	
 	thisSprite = event.target
 	if (event.phase == "ended") then
		-- print("main: spriteListener called", backgroundVY)
 		thisSprite:setFrame(1)
 		thisSprite:play()
 	end
 end




-----------------------
local function init()
	-- initialize player entity
	initPlayer()
	-- Animation sequence of player sprite:
	height = display.contentHeight
	width = display.contentWidth
	acc = 50 -- acceleration of obstacles
	xPositions = { 200 ,370, 520, 620} 	-- random horizontal positions
	obstacleVelocity = { 200, 150, 130, 170} -- different obstacle's velocity in y direction 

	-- initializing background
    backgroundVY = 200
	background1 = display.newImage(backgroundGroup, "Bg1-road.png", display.contentCenterX, display.contentCenterY )
	background2 = display.newImage(backgroundGroup, "Bg1-road.png", display.contentCenterX, -1334*0.5)

end
-------------------------------

-- function to initialize player vars
function initPlayer()

	player.width = 150
	player.height = 100
	player.x = display.contentWidth * 0.5 
	player.y = display.contentHeight - player.height* 0.5 - 70
	player.vx = 200
	-- sheet for player sprite
	local playerSheet = graphics.newImageSheet("t_1.png", {width = 44, height = 139, numFrames = 8, sheetContentWidth = 484, sheetContentHeight = 139} )
	-- sequence for player sprite
	local sequence = {
	
		{ -- Normal Run	
			name = "run",
			start = 1,
			count = 10,
			time = 800,
			loopCount = 1,
			loopDirection = "forward"
		},

		{ -- Hunting
			name = "hunt",
			frames = { 11},
			time = 1000
		}

	}
	player.sprite = display.newSprite(playerGroup, playerSheet, sequence)
	player.sprite.x = player.x 
	player.sprite.y = player.y
	player.sprite:play()
	player.dir = nil
end
-------------------------------


init()

player.sprite:addEventListener("sprite", spriteListener)
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener("enterFrame", update)

