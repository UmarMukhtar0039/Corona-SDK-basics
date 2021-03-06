local playerTypesMap = {}
local animationService = require("animationService")

function playerTypesMap.makePlayer(player, displayGroup, shadowGroup)
	if (player.type == "tiger") then
		player.width = 40
		player.height = 120
		-- setting player sheet
		local playerSheet = graphics.newImageSheet("tigerAnim.png", {width = 44, height = 139, numFrames = 11, sheetContentWidth = 484, sheetContentHeight = 139})
		local animSequence = {
			{ -- Normal Run	
				name = "run",
				start = 1,
				count = 10,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},

			{ -- Hunting
				name = "hunt",
				frames = { 11},
				time = 1000
			}
		}
		-- setting shadow sheet
		local shadowSheet = graphics.newImageSheet("tigerShadow.png", {width = 100, height = 186, numFrames = 11, sheetContentWidth = 1100, sheetContentHeight = 186})
		local shadowSequence = {
			{ -- Normal Run	
				name = "run",
				start = 1,
				count = 10,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},

			{ -- Hunting
				name = "hunt",
				frames = { 11},
				time = 1000
			}
		}
		-- player.sprite = display.newSprite(displayGroup, playerSheet, animSequence)
		player.sprite = animationService.newSprite(displayGroup, playerSheet, animSequence)
		player.shadow = animationService.newSprite(shadowGroup, shadowSheet, shadowSequence)
		
		-- player.sprite:setSequence("run")
		player.sprite:play()
		player.shadow:play()
		player.sprite.x = player.x
		player.sprite.y = player.y
		player.shadow.x = player.x
		player.shadow.y = player.y
	
		
		-- collision bounds	
		player.contentBound.width = player.width - 20 
		player.contentBound.height = player.height - 40
		player.contentBound.xOffset = nil
		player.contentBound.yOffset = -17 
		player.contentBound.xMin = player.x - player.contentBound.width * 0.5 
		player.contentBound.xMax = player.x + player.contentBound.width * 0.5
		player.contentBound.yMin = player.y - player.contentBound.height * 0.5 + player.contentBound.yOffset
		player.contentBound.yMax = player.y + player.contentBound.height * 0.5 + player.contentBound.yOffset
		-- for debug circle sprite 
		-- player.contentBound.x = player.x
		-- player.contentBound.y = player.y
		-- player.contentBound.radius = player.height * 0.5

		-- for Syncing spite animation speed/time with player's speed
	 	local function spriteListener( event )
		 	thisSprite = event.target
		 	local ratio = -player.vy/200 -- ratio of current velocity with max velocity
		 	if (ratio < 0.05) then -- minimum time scale value
		 		ratio = 0.05
		 	end
		 	thisSprite.timeScale = ratio -- scales time of animation sequence

		end
		-- for Syncing shadow animation speed/time with player's speed
		local function shadowListener( event )
			thisSprite = event.target
			local ratio = player.vy/200  + 0.05-- ratio of current velocity with max velocity
	 		if (ratio < 0.05) then -- minimum time scale value
	 			ratio = 0.05
		 	end
		 	thisSprite.timeScale = ratio -- scales time of animation sequence
		end

		player.sprite:addEventListener("sprite", spriteListener )
		player.shadow:addEventListener("sprite", shadowListener )

	end
	return player
end

return playerTypesMap






-- local function listener1( obj ) -- 
-- 				obj:setSequence("hunt")
-- 				obj:play()
-- 			end
-- 			local function listener2( obj ) -- 
-- 				obj:setSequence("run")
-- 				obj:play()
-- 			end
-- ebd
-- 			-- player.sprite:setSequence("hunt")
-- 			transition.to(player.sprite, { time = 500, y = player.y - 100, onStart = listener1})
-- 			transition.to(player.sprite, { time = 500, onComplete = listener2})