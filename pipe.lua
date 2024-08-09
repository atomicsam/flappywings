Pipe = Entity:extend()

function Pipe:new(x, y, maxHeight)
	Pipe.super.new(self, x, y)

	self.maxHeight = maxHeight
	self.width = 70
	self.height = love.math.random(50, maxHeight-200)
	self.spacing = 175
	self.speed = 150

	self.passedFront = false
	self.playerPassed = false
end

function Pipe:draw()	
	-- draw the top and bottom part of the pipe and create a gap for player to pass through
	love.graphics.setColor(221/255, 119/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(221/255, 119/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.height+self.spacing,
							self.width, self.maxHeight-self.height-self.spacing)
end

function Pipe:update(dt)
	self.x = self.x - self.speed * dt
end

function Pipe:reachedEnd()
	return self.x <= 200
end

function Pipe:passedEnd()
	return self.x <= 0 - self.width
end

function Pipe:updateScore(player)
	if not self.playerPassed and player.x > self.x + self.width then
		self.playerPassed = true
		player.score = player.score + 1
		return true
	end
end