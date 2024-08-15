Floor = Entity:extend()

function Floor:new(x)
	self.width = love.graphics:getWidth()
	self.height = love.graphics:getHeight()*0.2

	y = love.graphics:getHeight() - self.height
	Floor.super.new(self, x, y)
	self:importImage()
	self.speed = 250
end

function Floor:update(dt)
	self.x = self.x - self.speed * dt
end

function Floor:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.image, self.floorTiles[1], self.x, self.y, 0, 5, 5)
end

function Floor:importImage()
	self.image = love.graphics.newImage("assets/images/SimpleStyle1.png")
	self.floorTiles = {}

	self.frameWidth = 16
	self.frameHeight = 32

	for i=0,3 do
		table.insert(self.floorTiles, love.graphics.newQuad(i*self.frameWidth, 80,
						self.frameWidth, self.frameHeight ,self.image:getWidth(), self.image:getHeight()))
	end
end