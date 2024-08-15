Player = Entity:extend()

function Player:new(x, y)
	Player.super.new(self, x, y)

	self.gravity = 0
	self.weight = 30

	self.alive = false
	self.moving = false
	
	self.score = 0

	self.speedOfAnimation = 10
	self.rotation = 0

	self:loadPlayerImage()
end

function Player:update(dt)
	self.lastY = self.y
	if self.moving then
		self.gravity = self.gravity + self.weight * dt
		self.y = self.y + self.gravity
		if self.rotation < (math.pi/2) then
			if self.gravity >= 0 then
				self.rotation = self.rotation + 9 * dt
				self.width = self.width - 100 * dt
				self.height = self.originalHeight
			end
		else
			swooshSound:play()
			self.width = self.originalWidth - 30
			self.rotation = (math.pi/2)
			self.height = self.originalHeight + 25
		end
	end

	if self.alive then
		if love.keyboard.isDown("space") then
			wingSound:play()
			self.gravity = -7
			self.rotation = -0.75
			self.width = self.originalWidth - 10
			self.height = self.originalHeight
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
						self.x+self.width/2-5, (self.y+self.height/2)-7, self.rotation,
						self.scaleFactor, self.scaleFactor,
						(self.width/self.scaleFactor)/2, (self.height/self.scaleFactor)/2)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
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
	self.playerImage = love.graphics.newImage("assets/images/AllBird1.png")

	self.frames = {}
	self.numFrames = 4
	self.numFrameStyles = 7
	self.frameStyle = 2
	self.startFrame = (self.frameStyle - 1) * self.numFrames + 1

	local width = self.playerImage:getWidth()
	local height = self.playerImage:getHeight()

	self.frameWidth = width/self.numFrames
	self.frameHeight = height/self.numFrameStyles
	self.scaleFactor = 4

	
	self.originalWidth = (self.frameWidth * self.scaleFactor)
	self.width = self.originalWidth

	-- frame has empty space so -5 will offset this
	self.originalHeight = (self.frameHeight * self.scaleFactor) - 10
	self.height = self.originalHeight

	for i=0,6 do
		for j=0,3 do
			table.insert(self.frames, love.graphics.newQuad(j*self.frameWidth, 
							i*self.frameHeight,
							self.frameWidth, self.frameHeight,
							self.playerImage:getWidth(),
							self.playerImage:getHeight()))
		end
	end

	local count = 0
	for i=1,#self.frames do
		count = count + 1
	end
	
	self.currentFrame = self.startFrame
end

function Player:updateHighScore()
	if self.score > highScore then
		highScore = self.score
	end
end