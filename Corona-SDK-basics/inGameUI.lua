local inGameUI = {displayGroup = nil}

local menuBox  
local pauseText
local menuText
local resumeButton
local gw

-- called 
function inGameUI.makePauseMenu( )
	menuBox = display.newRect(gw.inGameUIGroup, display.contentCenterX, display.contentCenterY - 200, 400, 400)
	pauseText = display.newText(gw.inGameUIGroup, "Paused", menuBox.x, menuBox.y - 250 )
	menuText = display.newText(gw.inGameUIGroup, "Tap to Resume", menuBox.x, menuBox.y)
	resumeButton = display.newImage(gw.inGameUIGroup,"images.png" , menuBox.x, menuBox.y - 300)
end

------------------------

local function resumeGame( )
	gw.gameState = "resume"
	menuBox:removeSelf()
	menuBox = nil
	pauseText:removeSelf()
	pauseText = nil
	menuText:removeSelf()
	menuText = nil
	resumeButton:removeSelf()
	resumeButton = nil
end

------------------------
-- can be called from external script
function inGameUI.init( gameWorld )
	gw = gameWorld
end


resumeButton:addEventListener("tap", resumeGame)	

------------------------

return inGameUI