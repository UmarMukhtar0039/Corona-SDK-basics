local player = {
	displayGroup = nil,
	shadowGroup = nil,
}

local typesMap = require("playerTypesMap")


local player_mt = {__index=player}

function player.new( type,x,y )
	local newPlayer = { -- model of player
		type = type,
		x = x,
		y = y,
		vx = 200,
		vy = 200,
		height = nil,
		width = nil,
		dir = nil,
		sprite = nil,
		shadow = nil,
		--collision properties
		contentBound = {xMin = nil, yMin = nil, xMax = nil, yMax = nil, width = nil, height = nil}		
		-- contentBound = { x = nil, y = nil, radius = nil}
	}

	-- getting an instance updated with view of player
	newPlayer = typesMap.makePlayer(newPlayer, player.displayGroup, player.shadowGroup)

	-- Optional -- For Debug Only
	newPlayer.debugSprite = display.newRect(player.shadowGroup, newPlayer.x, newPlayer.y, newPlayer.contentBound.xMax - newPlayer.contentBound.xMin, newPlayer.contentBound.yMax - newPlayer.contentBound.yMin ) 
	-- newPlayer.debugSprite = display.newCircle(player.shadowGroup, newPlayer.x, newPlayer.y, newPlayer.contentBound.radius)
	
	return setmetatable(newPlayer, player_mt)
end

-------------------------
function player:updateBounds( )
	self.contentBound.xMin = self.x - self.contentBound.width * 0.5
	self.contentBound.xMax = self.x + self.contentBound.width * 0.5
	self.contentBound.yMin = self.y - self.contentBound.height * 0.5 + self.contentBound.yOffset
	self.contentBound.yMax = self.y + self.contentBound.height * 0.5 + self.contentBound.yOffset
	-- self.contentBound.x = self.x -- in case of circular sprite
	-- self.contentBound.y = self.y 
end

-- update view
function player:updateImages()
	self.sprite.x = self.x
	self.shadow.x = self.x
	-- updating debugSprite with player's sprite
	if (self.debugSprite ~= nil) then
		self.debugSprite.x = self.contentBound.xMin + self.contentBound.width * 0.5
		self.debugSprite.y = self.contentBound.yMin + self.contentBound.height * 0.5
	end
end

-------------------------

-- updates model and then call updateImage to update view
function player:update(dt)
	if (self.dir == "r") then
		self.x = self.x + self.vx * dt		
	elseif self.dir == "l" then
		self.x = self.x - self.vx * dt
	end

	-- updating view of player
	self:updateBounds()
	self:updateImages()
end

-------------------------

return player