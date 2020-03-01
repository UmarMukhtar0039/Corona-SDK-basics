local fps = {}

-- sum of delta Time for 100 frames
local dtSum
local countFrame
local fpsDispText


-- initializing all vars global to this script
-- called once in main
function fps.init(  )
	fpsDispText = display.newText("FPS: 60", display.contentWidth - 100 , 100)
	countFrame = 0
	dtSum = 0
end

-- updates the avgFps after 100 frames
-- called in main's update function
function fps.update(dt)
	countFrame = countFrame + 1
	dtSum = dtSum + dt
	
	-- after every 100'th frame avgFps will be updated
	if (countFrame == 100) then
		local dtMean = dtSum/100 -- mean of delta time of 100 frames
	    local avgFps = 1/dtMean
	    fpsDispText.text = "FPS: "..math.floor(avgFps) -- rounding the value to an integer

	    -- resetting countFrame and dtSum after every 100'th frame
		countFrame = 0
		dtSum = 0		
	end

end

return fps