Pipe = Entity:extend()

function Pipe:new(x, y, maxHeight)
	Pipe.super.new(self, x, y)

	self.maxHeight = maxHeight
	self.height = love.math.random(100, maxHeight-250)
	self.spacing = 150
	
	if not pipeSpeed then
		pipeSpeed = 250
	end

	self.pipe2y = self.height + self.spacing
	self.pipe2height = self.maxHeight-self.height-self.spacing
	
	self.image = love.graphics.newImage("assets/images/PipeStyle1.png")
	self:importImage()

	-- account for the quad and scale factor
	self.width = (self.image:getWidth()/4)*3

	self.passedFront = false
	self.playerPassed = false

	self.lastX = self.x
end

function Pipe:draw()	
	-- draw the top and bottom part of the pipe and create a gap for player to pass through
	love.graphics.setColor(119/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.image, self.pipeStyles[self.currentStyle+1], self.x, 
		self.height - self.frameHeight - 40, 0, 3, 3)
	love.graphics.draw(self.image, self.pipeExtension, self.x, 0, 0, 3, self.height-self.frameHeight)

	-- draw bottom pipe
	love.graphics.setColor(119/255, 221/255, 119/255)
	love.graphics.rectangle("fill", self.x, self.pipe2y,
							self.width, self.pipe2height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.image, self.pipeStyles[self.currentStyle], self.x, self.pipe2y, 0, 3, 3)
	love.graphics.draw(self.image, self.pipeExtension, self.x, self.pipe2y+(self.image:getHeight()/4)*3, 0, 3, 3*self.pipe2height)
end

function Pipe:update(dt)
	self.lastX = self.x
	self.x = self.x - pipeSpeed * dt
end

function Pipe:reachedEnd()
	return self.x <= 400
end

function Pipe:passedEnd()
	return self.x <= 0 - self.width
end

function Pipe:updateScore(player)
	if not self.playerPassed and player.x > self.x + self.width then
		self.playerPassed = true
		player.score = player.score + 1
		pointSound:play()
		if math.fmod(player.score, 10) == 0 and score ~= 0 then
			pipeSpeed = pipeSpeed + 50
		end
		return true
	end
end

-- a function that pushes the player back so the game looks neater
function Pipe:resolvePlayerCollision(player)
	if player.x + player.width >= self.lastX
	and player.x < self.lastX + self.width then
		if player.y < self.y + self.height then
			local dif = self.y + self.height - player.y
			player.y = player.y + dif
		else
			local dif = (player.y + player.height) - (self.y + self.height + self.spacing)
			player.y = player.y - dif
		end
	else
		local dif = player.x + player.width - self.x
		player.x = player.x - dif
	end
end

function Pipe:importImage()
	self.pipeStyles = {}
	self.currentStyle = 1

	local rows = 2
	local columns = 4
	local frameWidth = self.image:getWidth()/columns
	self.frameHeight = self.image:getHeight()/rows

	for i=0,1 do
		for j=0,3 do
			for k=0,1 do
				table.insert(self.pipeStyles, love.graphics.newQuad(j*frameWidth,
								i*self.frameHeight+(k*self.frameHeight*0.5),
								frameWidth, self.frameHeight/2, self.image:getWidth(),
								self.image:getHeight()))
			end
		end
	end

	self.pipeExtension = love.graphics.newQuad(0, 30, frameWidth, 1, self.image:getWidth(), 
												self.image:getWidth())
end