Floor = Entity:extend()

function Floor:new(x, y)
	Floor.super.new(self, x, y)
	
	self.width = 720
	self.height = 400
end

function Floor:draw()
	love.graphics.setColor(119/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end