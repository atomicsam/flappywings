Player = Entity:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)

	self.gravity = 0
	self.weight = 30

	self.alive = false
	self.score = 0

	self.speedOfAnimation = 15

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
		self.currentFrame = self.currentFrame + self.speedOfAnimation * dt
		if self.currentFrame >= (self.startFrame - 1) + self.numFrames then
			self.currentFrame = self.startFrame
		end
	end
end

function Player:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.playerImage, self.frames[math.floor(self.currentFrame)],
						self.x, self.y, 0, self.scaleFactor, self.scaleFactor)
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
	self.playerImage = love.graphics.newImage("assets/Player/StyleBird1/AllBird1.png")

	self.frames = {}
	self.numFrames = 4
	self.numFrameStyles = 7
	self.frameStyle = 1
	self.startFrame = (self.frameStyle - 1) * self.numFrames + 1

	local width = self.playerImage:getWidth()
	local height = self.playerImage:getHeight()

	self.frameWidth = width/self.numFrames
	self.frameHeight = height/self.numFrameStyles
	self.scaleFactor = 4
	self.width = self.frameWidth * self.scaleFactor
	self.height = self.frameHeight * self.scaleFactor

	for i=0,6 do
		for j=0,3 do
			table.insert(self.frames, love.graphics.newQuad(j*self.frameWidth, i*self.frameHeight,
							self.frameWidth, self.frameHeight, self.playerImage:getWidth(),
							self.playerImage:getHeight()))
		end
	end

	local count = 0
	for i=1,#self.frames do
		count = count + 1
	end
	
	self.currentFrame = self.startFrame
end