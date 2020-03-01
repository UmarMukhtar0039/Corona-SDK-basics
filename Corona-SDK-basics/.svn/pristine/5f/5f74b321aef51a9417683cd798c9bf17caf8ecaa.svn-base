shakeEffect={
	displayGroup=nil,
}
local debugStmt=require "scripts.helperScripts.printDebugStmt"
local shakeTimer,shakeTimeLimit,shakeSpeed,triggerReposition,movePattern,movecyclerr
local myMath=
			{
				random=math.random
			}


function shakeEffect.init(displayGroup)
	shakeEffect.displayGroup=displayGroup
	shakeTimer=0--timer that governs the shakeEffect
	shakeTimeLimit=0--duration of shake
	shakeSpeed=8--the amount by which the view must be shaked
  triggerReposition=false--set it true to trigger the repositioning mechanism of the display group
  --assign a pattern for shake to look more natural. Using random leads to inappropriate behaviour at lower fps.
  movePattern=
  {
    {x=-1,y=0},
    {x=1,y=0},
    {x=0,y=-1},
    {x=0,y=1},
    {x=1,y=0},
    {x=-1,y=0},
    {x=0,y=1},
    {x=0,y=-1},
  }
  moveCycler=1--init cycler to 1
end

------------------------------------

function shakeEffect.update(delta)
  
	--if the shaking timer is triggered shake the screen
  if(shakeTimer~=0)then
	 shakeTimer=shakeTimer+delta
    
    local motion
    local delX,delY
    --select one of the 
    delX=movePattern[movecyclerr].x*shakeSpeed
    delY=movePattern[movecyclerr].y*shakeSpeed
    --increment cyclerr and reset if it exceeds the size of pattern table
    movecyclerr=movecyclerr+1
    if(movecyclerr>#movePattern)then
      movecyclerr=1
    end

    --once the direction is set apply the movement to the display group in that direction
    shakeEffect.displayGroup.x=shakeEffect.displayGroup.x+delX
    shakeEffect.displayGroup.y=shakeEffect.displayGroup.y+delY
  end
  --once the limit is over, set the timer to 0 and reset the position of the display group
  if(shakeTimer>shakeTimeLimit)then
    shakeTimer=0
    triggerReposition=true
  end
  --reposition the displayGroup 
  if(triggerReposition)then
    local xChange,yChange,isRepositioned
    isRepositioned=true--this bool indicates if the display group has reached its mean position or not

    --compute the difference of displayGroups current position from its mean position,and move it accordingly
    xChange=0-shakeEffect.displayGroup.x
    yChange=0-shakeEffect.displayGroup.y
    if(xChange>2)then--an error of 2px is given
      shakeEffect.displayGroup.x= shakeEffect.displayGroup.x+shakeSpeed*delta
      isRepositioned=false
    elseif(xChange<-2)then
      shakeEffect.displayGroup.x= shakeEffect.displayGroup.x-shakeSpeed*delta
      isRepositioned=false
    end
    if(yChange>2)then
      shakeEffect.displayGroup.y=shakeEffect.displayGroup.y+shakeSpeed*delta
      isRepositioned=false
    elseif(yChange<-2)then
      shakeEffect.displayGroup.y=shakeEffect.displayGroup.y-shakeSpeed*delta
      isRepositioned=false
    end
    --if the display group has reached its mean position then disable the the reposition mechanism
    if(isRepositioned)then
      triggerReposition=false
    end
  end
end

------------------------------------
--function triggers the shake effect and sets the duration
function shakeEffect.shake(shakeDuration)
	shakeTimeLimit=shakeDuration
	shakeTimer=0.1
end

return shakeEffect