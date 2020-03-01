gameplayManager = {}

local player -- will contain reference of player from game world
local score
local scoreText
local setupDisplayObjects -- functoin to setup score display
local updatePlayer -- will update player's score
local updateDisplayObjects  -- will update display objects (score text)
local displayObjects -- contains reference to all display objects in gameplay manager
local distance

-----------------------------
-- initialize all elements in Gameplay Manager
function gameplayManager.init( player1 )
	player = player1
	score = player.score
	distance = 0
	setupDisplayObjects()
end

-----------------------------

-- init display objects
function setupDisplayObjects() -- sets up score text to display
	scoreText = display.newText("Score: "..score, display.contentWidth - 100 , 100)
end

-----------------------------
function gameplayManager.update(dt)
	updatePlayer(dt)
	updateDisplayObjects()
end

-----------------------------
-- update score of player
function updatePlayer(dt)
	local scaleFactor = 0.012
	distance = distance - player.vy * dt -- distance will keep on increasing
	player.score = math.round(distance * scaleFactor) -- scaling the distance by scale factor and rounding off the value
end

-----------------------------
-- update text in score
function updateDisplayObjects()
	scoreText.text = "Score: "..player.score
end

-----------------------------

return gameplayManager