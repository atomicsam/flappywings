Player = Entity:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)
	self.width = 50
	self.height = 50
	self.gravity = 0
end

function Player:update(dt)
	self.gravity = self.gravity + self.y * dt
	self.y = self.y + self.gravity
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end