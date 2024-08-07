Floor = Entity:extend()

function Floor:new()
	self.width = love.graphics:getWidth()
	self.height = love.graphics:getHeight()*0.2

	y = love.graphics:getHeight() - self.height
	Floor.super.new(self, 0, y)
end

function Floor:draw()
	love.graphics.setColor(119/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end