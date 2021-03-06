local particleSystem = {displayGroup = nil}

local emmiter = {} -- single emmiter
local xPositions = {} -- 3 different positions as per gaussian distribution
local yPositions = {}
local colour = {} -- contains 3 different colours 
local timer
local timeLimit

-- fwd reference
local updateParticle
local removeParticle

-----------------------------

--initialize the emmiter and return a reference of it 
function particleSystem.init(playerX, playerY)

	colour 	   = { {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, 
				   {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, 
				   {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, {r = 205/255, g = 174/255, b = 116/225}, 
				 }-- contains 9 colours for different particles
	timer = 0
	emmiter = {
		x = playerX, y = playerY,
		xVar = { -10, 0,10},
		yVar = 0, -- initially 0
		vx = 0,vy = 0,
		vxVar = {-100, -75, -50, -25, 0, 25, 50, 75, 100},
		-- vyVar = {-100, 0, 100},
		life = 1, -- life time of each particle in seconds
		count = 3, -- no. of particles to spawn at once
		emmissionRate = 25, -- emit in 1 sec
		startScale = 0.5,
		endScale = 2,
		particles = {}, -- array to contain all particles's reference
	}
	
	timeLimit = 1/emmiter.emmissionRate
end

-----------------------------

-- if timer become greater from timeLimit spawn count no. of particles
function particleSystem.update( playerX, playerY, worldVY, dt )
	timer = timer + dt
	emmiter.y = playerY
	emmiter.x = playerX
	
	-- emmiter.yVar = { -20, -15, - 10, -5, 0, 5, 10, 15, 20}


	if timer >= timeLimit then
		-- spawning

		for i=1,emmiter.count do
			local selector = math.random(#colour) -- will selector any random positions from xPositions, yPositions table
			local xPositions = math.random(#emmiter.xVar)
			emmiter.particles[#emmiter.particles+1] = display.newImage(particleSystem.displayGroup, "dustParticle.png", emmiter.x + emmiter.xVar[xPositions] , emmiter.y + 15) -- spawning new particle
			emmiter.particles[#emmiter.particles].timer = 0 -- giving a particle its own timer
			-- emmiter.particles[#emmiter.particles].xScale = emmiter.startScale
			-- emmiter.particles[#emmiter.particles].yScale = emmiter.startScale
			emmiter.particles[#emmiter.particles]:scale(emmiter.startScale, emmiter.startScale)
			emmiter.particles[#emmiter.particles].vx = emmiter.vxVar[selector] - 0 -- giving particle a horizontal velocity
			emmiter.particles[#emmiter.particles].vy = emmiter.vy - worldVY-- giving particle a vertical velocity
			emmiter.particles[#emmiter.particles]:setFillColor(colour[selector].r, colour[selector].g, colour[selector].b, 0.80) -- setting random colour
		end
	    
	    timer = 0 -- reset timer
	end

	-- updating particles if present in array
	for i=#emmiter.particles,1,-1 do
		if emmiter.particles[i].timer < emmiter.life then
			updateParticle( emmiter.particles[i], dt) -- updating individual particles
			
			emmiter.particles[i].alpha = emmiter.particles[i].alpha * (1 - emmiter.particles[i].timer / emmiter.life )-- if particle's life is 70 % complete fade it by 80%
			-- emmiter.particles[i]:scale( emmiter.endScale * (emmiter.particles[i].timer / emmiter.life) , 
			-- 							emmiter.endScale * (emmiter.particles[i].timer  / emmiter.life))
			emmiter.particles[i].xScale = emmiter.startScale + (emmiter.endScale - emmiter.startScale) * (emmiter.particles[i].timer  / emmiter.life)
			emmiter.particles[i].yScale = emmiter.startScale + (emmiter.endScale - emmiter.startScale) * (emmiter.particles[i].timer  / emmiter.life)
			-- print("Scale "..emmiter.endScale * (emmiter.particles[i].timer  / emmiter.life))
		else
			removeParticle( emmiter.particles[i], i)
		end
	end

	print("table SIze "..#emmiter.particles)
end

-----------------------------

-- updates a particle's position and timer
function updateParticle(particle, dt)
	particle.timer = particle.timer + dt -- increment timer
	particle.x = particle.x + particle.vx * dt
	particle.y = particle.y + particle.vy * dt
end

-----------------------------

function removeParticle( particle, i)
	table.remove(emmiter.particles, i)
	particle:removeSelf()
	particle = nil
end
-----------------------------

return particleSystem