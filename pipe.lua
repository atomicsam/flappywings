Pipe = Entity:extend()

function Pipe:new(x, y, maxHeight)
	Pipe.super.new(self, x, y)

	self.maxHeight = maxHeight
	self.width = 70
	self.height = love.math.random(50, maxHeight-200)
	self.spacing = 175
	self.speed = 50

	-- for testing
	self.time = 2
end

function Pipe:draw()
	love.graphics.setColor(221/255, 119/255, 119/255)
	
	-- draw the top and bottom part of the pipe and create a gap for player to pass through
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(0/255, 0/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.height+self.spacing,
							self.width, self.maxHeight-self.height-self.spacing)
end

function Pipe:update(dt)
	self.x = self.x - self.speed * dt
	if self.time < 0 then
		self.height = love.math.random(50, self.maxHeight-self.spacing)
		self.time = 2
	else
		self.time = self.time - dt
	end
end

function Pipe:reachedEnd()
	
end