function love.load()
	success = love.window.setMode(720, 800)
	-- love.graphics.setBackgroundColor(173/255, 216/255, 230/255, 1)
	love.graphics.setDefaultFilter("nearest", "nearest")
	backgroundImage = love.graphics.newImage("assets/Background/Background2.png")
	logo = love.graphics.newImage("assets/images/logo.png")

	windowWidth = love.graphics:getWidth()
	windowHeight = love.graphics:getHeight()
	textHeight = windowHeight * 0.15

	font = love.graphics.newFont("fonts/firasanscompressed-book.otf", 24)
	font:setFilter("nearest")

	-- restartText = "Press F2 to restart the game!"
	-- textCenterRestart = getTextCenter(font, restartText)
	-- startText = "Press space to get the game started"
	-- textCenterStart = getTextCenter(font, startText)

	flashDuration = 0.1
	highScore = 0

	importSounds()
	gameStarted = false

	Object = require "classic"
	require "entity"
	require "player"
	require "pipe"
	require "score"
	require "floor"
	require "sky"

	firstFloorEntity = Floor(0)
	floorTable = {}
	table.insert(floorTable, firstFloorEntity)
	generateFloor()

	playerStartingX = windowWidth * 0.3
	playerStartingY = (windowHeight-firstFloorEntity.height)*0.42
	tempPlayer = Player(playerStartingX, playerStartingY)
	pipes = {}
end

function love.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(backgroundImage, 0, -20, 0, 2.85, 2.85)
	for i,pipe in ipairs(pipes) do
		pipe:draw()
	end
	tempPlayer:draw()

	-- print appropriate text
	love.graphics.setColor(0, 0, 0, 1)
	if not gameStarted then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(logo, windowWidth/2-logo:getWidth(), 10, 0, 2, 2)
		printTextCenter(font, "Press space to get the game started", textHeight)

	elseif not tempPlayer.alive then
		printTextCenter(font, "Press F2 to restart the game!", textHeight)
		printTextCenter(font, "High Score: "..highScore, 10)
	end
	printTextCenter(font, "Score: " .. tempPlayer.score, textHeight - 30)
	for i, entity in ipairs(floorTable) do
		entity:draw()
	end

	if tempPlayer.moving and not tempPlayer.alive then
		flash()
	end
end

function love.update(dt)
	if tempPlayer:hitFloor(firstFloorEntity) and tempPlayer.moving then
		dieSound:play()
		tempPlayer.alive = false
		tempPlayer.moving = false
		tempPlayer.y = firstFloorEntity.y - tempPlayer.height
		tempPlayer:updateHighScore()
	elseif tempPlayer.moving then
		tempPlayer:update(dt)
		if tempPlayer.alive then
			drawPipes(pipes, dt)
		end
	end

	if tempPlayer.alive then
		for i, floor in ipairs(floorTable) do
			floor:update(dt)
		end
	end
	drawFloorTable()

	if flashDuration > 0 and not tempPlayer.alive and tempPlayer.moving  then
		flashDuration = flashDuration - dt
	end
end

function love.keypressed(key)
	if key == "f2" and not tempPlayer.alive and gameStarted then
		startGame()
	end
	if key == "space" and not gameStarted then
		gameStarted = true
		startGame()
	end
end

function startGame()
	tempPlayer = Player(playerStartingX, playerStartingY)
	tempPlayer.alive = true
	tempPlayer.moving = true
	flashDuration = 0.1

	pipes = {}
	table.insert(pipes, Pipe(love.graphics:getWidth(), 0, firstFloorEntity.y))
end

-- function getTextCenter(font, text)
-- 	return windowWidth/2 - font:getWidth(text)/2
-- end

function printTextCenter(font, text, height)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(text, font, windowWidth/2 - font:getWidth(text)/2, height)
end

function drawPipes(pipeTable, dt)
	for i, pipe in ipairs(pipeTable) do
		-- collision detection
		if tempPlayer:hitPipe(pipe) then
			hitSound:play()
			tempPlayer.alive = false
			pipe:resolvePlayerCollision(tempPlayer)
			tempPlayer:updateHighScore()
			break
		end

		if tempPlayer.alive then
			pipe:update(dt)
			pipe:updateScore(tempPlayer)
			if pipe:reachedEnd() and not pipe.passedFront then
				table.insert(pipeTable, Pipe(love.graphics:getWidth(), 0, firstFloorEntity.y))
				pipe.passedFront = true
			end
			if pipe:passedEnd() then
				table.remove(pipeTable, i)
			end
		end
	end
end

function drawFloorTable()
	if floorTable[1].x < (0 - firstFloorEntity.frameWidth*5) then
		print(floorTable[1].x)
		table.remove(floorTable, 1)
		table.insert(floorTable, Floor(floorTable[#floorTable].x + firstFloorEntity.frameWidth*5))
	end
end

function generateFloor()
	for i=1,9 do
		table.insert(floorTable, Floor((firstFloorEntity.frameWidth*5)*i))
	end
end

function importSounds()
	dieSound = love.audio.newSource("assets/audio/sfx_die.wav", "static")
	hitSound = love.audio.newSource("assets/audio/sfx_hit.wav", "static")
	pointSound = love.audio.newSource("assets/audio/sfx_point.wav", "static")
	swooshSound = love.audio.newSource("assets/audio/sfx_swooshing.wav", "static")
	wingSound = love.audio.newSource("assets/audio/sfx_wing.wav", "static")
end

function flash()
	if flashDuration > 0 then
		love.graphics.setColor(1, 0.2, 0.2, 0.2)
		love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
	end
end