Player = Entity:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)
	self.width = 50
	self.height = 50

	self.gravity = 0
	self.weight = 30

	self.alive = true
end

function Player:update(dt)
	self.gravity = self.gravity + self.weight * dt
	self.y = self.y + self.gravity

	if love.keyboard.isDown("space") then
		self.gravity = -7
	end
end

function Player:draw()
	love.graphics.setColor(221/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	if self.alive == false then
		love.graphics.print("Press F2 to restart the game!", 300, 200)
	end
end

function Player:hitFloor(floorEntity)
	return self.y + self.height >= floorEntity.y
end