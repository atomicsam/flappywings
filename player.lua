Player = Entity:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)
	self.width = 50
	self.height = 50

	self.gravity = 0
	self.weight = 30

	self.alive = false
	self.score = 0

	self.playerImage = love.graphics.newImage("assets/Player/StyleBird1/AllBird1.png")
	self:loadPlayerImage()
	-- self.lastY = self.y
end

function Player:update(dt)
	self.lastY = self.y
	if self.alive then
		self.gravity = self.gravity + self.weight * dt
		self.y = self.y + self.gravity

		if love.keyboard.isDown("space") then
			self.gravity = -7
		end
	end
end

function Player:draw()
	love.graphics.setColor(221/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.draw(self.playerImage, self.frames[self.currentFrame], 100, 100)
	if self.currentFrame < self.numFrames then
		self.currentFrame = self.currentFrame + 1
	else
		self.currentFrame = 1
	end
end

function Player:hitFloor(floorEntity)
	return self.y + self.height >= floorEntity.y
end

function Player:hitPipe(pipeEntity)
	return self.x <= pipeEntity.x + pipeEntity.width
	and self.x + self.width >= pipeEntity.x
	and (self.y <= pipeEntity.height or self.y + self.height >= pipeEntity.height + pipeEntity.spacing)
end

function Player:loadPlayerImage()
	self.frames = {}
	self.numFrames = 4

	local width = self.playerImage:getWidth()
	local height = self.playerImage:getHeight()

	local frameWidth = width/4
	local frameHeight = height/7

	for i=1,4 do
		for j=1,7 do
			table.insert(self.frames, love.graphics.newQuad(i*frameWidth, j*frameHeight,
							frameWidth, frameHeight, self.playerImage:getWidth(),
							self.playerImage:getHeight()))
		end
	end
	
	self.currentFrame = 1
	-- return frames
end