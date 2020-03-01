local slowMotionEffect={}

-- local debugStmt=require "scripts.helperScripts.printDebugStmt"
local deltaTime=require "deltaTime"

--Variables that is used in playing the Slow Motion Effect
local isSlowMotion--Indicates whether the slow motion effect is currently active. If this is on, the play fn will ignore calls made to it
local isPaused=false--used to stop the effect temporarily and continue later in time. the variable will indicate if the effect is currently paused
local slowMotionTimer=0 slowMotiontimeLimit=0--variables that control the duration and transition of slow motion effect
local slowMotionFraction=0.3
------------------------------
local function update()
	dt=deltaTime.getDelta()

	--increment the timer only if slow Motion is active and currently not paused
	if(isSlowMotion and not isPaused)then
		slowMotionTimer=slowMotionTimer+dt
		--the set value of delta time fraction will remain for the first half of the duration and then it will be slowly restored to the default value  
		if(slowMotionTimer>slowMotionTimeLimit*0.5 and slowMotionTimer<slowMotionTimeLimit)then
			deltaTime.fraction=slowMotionFraction+slowMotionTimer/slowMotionTimeLimit*0.7
		elseif(slowMotionTimer>=slowMotionTimeLimit)then--on completion of the effect
			slowMotionTimer=0
			slowMotiontimeLimit=0
			deltaTime.fraction=1
			isSlowMotion=false
		end
	end
end

--------------------------------------
--this function will be called by external scripts to play the slowmotion effect 
--The duration for the slowMotion (in milliseconds) is accepted as a parameter
function slowMotionEffect.play(duration)
	--if already playing, return
	if(isSlowMotion)then
		return
	end

	deltaTime.fraction=slowMotionFraction--set a value of delta time fraction
	slowMotionTimeLimit=duration/1000--set the value of slow motion time limit equal to the duration passed and convert it to seconds
	isSlowMotion=true--raise the flag to block recurring calls, this should also initiate the updation of timers		
end

--------------------------------------
--this function will be called by external scripts to pause the slowmotion effect 
function slowMotionEffect.pause()
	--if not playing, return
	if(not isSlowMotion)then
		return
	end

	isPaused=true--this will stop the updation of the timers and the delta time fraction
end

--------------------------------------
--this function will be called by external scripts to resume the slowmotion effect 
function slowMotionEffect.resume()
	--if not playing, return
	if(not isSlowMotion)then
		return
	end

	isPaused=false--this will resume the updation of the timers and the delta time fraction
end

--------------------------------------
--this function will be called by external scripts to cancel the slowmotion effect 
function slowMotionEffect.cancel()
	isPaused=false--reset the value of isPaused
	isSlowMotion=false--this will stop the updation of the timers and the delta time fraction
	--reset the value of delta time fraction to its original value 
	deltaTime.fraction=1
	--reset the value of slow motion time limit
	slowMotionTimer=0
	slowMotiontimeLimit=0
end

------------Init runtime Listener-------------
Runtime:addEventListener ( "enterFrame", update )

return slowMotionEffect