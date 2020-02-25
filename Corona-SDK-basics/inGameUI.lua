local inGameUI = {}

--------local Variables--------
local gw -- gets a reference of gameWorld in init function
local pauseMenuDG -- pause Menu display items will be referenced in this table

--------Fwd References--------
local removeUI -- function to remove a complete UI group


-- called from external script to make a pause menu
function inGameUI.makePauseMenu( displayGroup )
	local menuBox
	local resumeButton
	
	menuBox = display.newRect(displayGroup, display.contentCenterX, display.contentCenterY , 400, 400)
	menuBox.alpha = 0.2
	pauseMenuDG[#pauseMenuDG + 1] = menuBox
	
	-- Title of Pause Menu
	pauseMenuDG[#pauseMenuDG + 1] = display.newText(displayGroup, "Paused", menuBox.x, menuBox.y - 250 )
	-- pauseMenuDG[#pauseMenuDG+1] = title
	
	-- Text in Menu
	pauseMenuDG[#pauseMenuDG + 1] = display.newText(displayGroup, "Tap to Resume", menuBox.x, menuBox.y - 50)
	-- pauseMenuDG[#pauseMenuDG+1] = menuText
	
	resumeButton = display.newImage(displayGroup,"images.png" , menuBox.x, menuBox.y + 80)
	pauseMenuDG[#pauseMenuDG + 1] = resumeButton

	-- nested function to change gameState and remove display items
	local function resumeGame( )
		gw.gameState = "resume"
		removeUI(pauseMenuDG) -- removes display objects of Pause Menu
	
	end
	
	resumeButton:addEventListener("tap", resumeGame)	
end

------------------------

-- this function can remove a particular UI group
function removeUI(group )
	for i=#group,1,-1 do
		local temp = table.remove( group,i )
		temp:removeSelf()
		temp = nil
	end
end

------------------------
-- coroutine.isyieldable( ) called from external script
function inGameUI.init( gameWorld )
	gw = gameWorld
	pauseMenuDG = {}
end


------------------------

return inGameUI