-- this is a helper script, used to compute Delta Time and this script can be used by other files as well
local  deltaTime = {}

local prevTime = 0
local dt = 0

-- called every frame, computes deltaTime
local function update()
	local currentTime = system.getTimer() / 1000
	dt = currentTime - prevTime
	prevTime = currentTime
end

----------------

--returns deltaTime in sec
function deltaTime.getDeltaTimeInSec()	
	return dt 
end

----------------

Runtime:addEventListener("enterFrame", update)

return deltaTime
