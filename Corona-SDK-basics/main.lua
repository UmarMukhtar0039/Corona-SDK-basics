
local deltaTime = require("deltaTime")

local prevTime = 0
local spawnedObjects = { } -- table of spwaned objects in game 	
local spawnTimer = 0
local spawnTimeLimit = 3 -- in seconds
local height = display.contentHeight
local width = display.contentWidth
local acc = 50 -- acceleration of obstacles

-- forward references
local updatePlayer

-- this is the player we will possess in future
local player = { 	}

-- function to initialize player vars
local function initPlayer()
			player.width = 150
			player.height = 100
			player.x = player.width/2
			player.y = display.contentHeight - player.height/2
			player.vx = 200
			player.vy = 200
			player.sprite = display.newRect(player.x, player.y, player.width, player.height)
			player.dir = nil
end




-- this table contains color, opacity, velocity, scale of obstacles
local attributes = { 
	{ --this is red block

		r = 1,
		g = 0,
		b = 0,
		op = .5,
		vy = 700,
		scale = 
		{
			xScale = 2,
			yScale = 1.5 

		}
	}, 
	
	{ -- this is green block
		r = 0,
		g = 1,
		b = 0,
		op = .8,
		vy = 320,
		scale = 
		{
			xScale = 1.7,
			yScale = 1

		}
	},
	
	{ -- this is blue block
		r = 0,
		g = 0,
		b = 1,
		op = .4,
		vy = 400,
		scale = 
		{
			xScale = 0.8,
			yScale = 0.5 

		}
	},	
	
	{ -- this is pink block
		r = 1,
		g = 0,
		b = 1,
		op = .9,
		vy = 500,
		scale = 
		{
			xScale = 1,
			yScale = 1.5 
		}
	}

}


-- initialize player entity
initPlayer()

-- random horizontal positions
xPositions = { 200 ,370, 520, 620}
local text
local count = 0
function update(event)
	
	-- -- calculating delta time 
	-- local currentTime = system.getTimer() / 1000
	-- local deltaTime = currentTime - prevTime
	-- prevTime = currentTime
	text = display.newText(count, 500,500)

	local dt = deltaTime.getDeltaTimeInSec()

	-- -- this updates player's view and model
	updatePlayer(dt)
	--- this will spawn our player

		-- this block of code deals with spawning of objects 
	spawnTimer = spawnTimer + dt

	-- object will be spawned after spawnTimeLimit
	if spawnTimer > spawnTimeLimit then
		-- selects a position on x axis, a random scale and color from table : xPositions, scale, color
		local selector = math.random(#xPositions)
		
		-- if xPositions == 1 then

		-- end 
		
		local object = display.newRect( xPositions[selector] , -5, 150, 100)	
		object.vy = attributes[selector].vy -- this is vertical velocity of the obstacle defined in attributes table
		-- setting random colors and scale from attributes table using a single selector
		object:setFillColor(attributes[selector].r, attributes[selector].g, attributes[selector].b, attributes[selector].op)
		
		-- this superseeds the scale function if this is used then the scale function will set the scale w.r.t the scale set using this var
		-- object.xScale = attributes[selector].scale.xScale
		-- object.yScale = attributes[selector].scale.yScale
		object:scale( attributes[selector].scale.xScale , attributes[selector].scale.yScale)
		
		spawnedObjects[#spawnedObjects+1] = object
		
		-- resetting the timer to 0 after spawning
		spawnTimer = 0
	end
	
	-----------------

	-- this block of code will move the objects in the table
	for i = 1, #spawnedObjects do
		spawnedObjects[i].vy = spawnedObjects[i].vy + acc * dt
 		spawnedObjects[i].y = spawnedObjects[i].y + spawnedObjects[i].vy * dt 
		-- print ("main speed of object ".. i.. " : "..spawnedObjects[i].vy)		
	end
	
	-----------------

	-- removing objects from spawnedObjects table as it goes out of screen
	for i =  #spawnedObjects, 1, -1 do  
	 	
	 	-- if obj goes beyond screen remove it from table and delete it
	 	if 	spawnedObjects[i].y - spawnedObjects[i].height > height then 
			local temp = table.remove(spawnedObjects,i )
			temp:removeSelf()
			temp = nil
		end
	end
	-----------
	-- score
	-- count = count + 1
	-- if text ~= nil and count % 2 == 0 then
	-- 	text:removeSelf()
	-- 	text = nil
	-- end
end

------------------------

-- this function will update the player's model and view
-- don't define this local again when it is already fwd ref. as local var
function updatePlayer(dt)
	  -- this is part of model
 	if player.dir == "r" then
		player.x = player.x + player.vx * dt
	 	
 	elseif player.dir == "l" then
		player.x = player.x - player.vx * dt

	elseif player.dir == "u" then
		player.y = player.y - player.vy * dt
		
	elseif player.dir == "d" then
		player.y = player.y + player.vy * dt
	end


  	---- this is part the of view
	player.sprite.x = player.x
  	player.sprite.y = player.y
  	
end


------------------------
local tempText = nil

-- setting w,a,s,d keys for moving up,left,down,right
local function onKeyEvent( event )

	if event.phase == "down" then
    	if event.keyName == "d" then 
    		player.dir = "r"
	 	
		elseif event.keyName == "a" then
	    	player.dir = "l"
		
		elseif event.keyName == "w" then
			player.dir = "u"
		
		elseif event.keyName == "s" then
			player.dir = "d"
		
		else
			player.dir = nil
		end
		-- display keyname on screen
		tempText = display.newText(event.keyName,display.contentCenterX, display.contentCenterY)
	end

	if event.phase == "up" then
		player.dir = nil
		if tempText ~= nil then			
			tempText:removeSelf()
			tempText = nil
		end
    end
	
    return false
end




-- local rect = display.newText("hello",200,200)

-- local function onkey( event )
-- 	if event.phase == "down" then
-- 		rect:removeSelf()
-- 		rect = nil
-- 	end	
	
-- end

-- Runtime:addEventListener("key", onkey)


-- local function onKeyEvent( event )
-- 	if event.phase == "down" then
-- 		tempText = display.newText(event.keyName,200,200)
-- 	end

-- 	if event.phase == "up" then
-- 		tempText:removeSelf()
-- 		tempText = nil
-- 	end
-- end

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

Runtime:addEventListener("enterFrame", update)