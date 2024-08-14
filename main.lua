function love.load()
	success = love.window.setMode(720, 800)
	-- love.graphics.setBackgroundColor(173/255, 216/255, 230/255, 1)
	love.graphics.setDefaultFilter("nearest", "nearest")
	backgroundImage = love.graphics.newImage("assets/Background/Background2.png")

	windowWidth = love.graphics:getWidth()
	windowHeight = love.graphics:getHeight()
	textHeight = windowHeight * 0.15

	font = love.graphics.newFont("fonts/firasanscompressed-book.otf", 24)
	-- font:setFilter("nearest")
	restartText = "Press F2 to restart the game!"
	textCenterRestart = getTextCenter(font, restartText)
	startText = "Press space to get the game started"
	textCenterStart = getTextCenter(font, startText)

	gameStarted = false

	Object = require "classic"
	require "entity"
	require "player"
	require "pipe"
	require "score"
	require "floor"
	require "sky"

	tempFloor = Floor()
	playerStartingX = windowWidth * 0.3
	playerStartingY = (windowHeight-tempFloor.height)*0.42
	tempPlayer = Player(playerStartingX, playerStartingY)
	-- tempPlayer:loadPlayerImage()
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
		love.graphics.print(startText, font, textCenterStart, textHeight)
	elseif not tempPlayer.alive then
		love.graphics.print(restartText, font,
			textCenterStart, textHeight)
	end
	love.graphics.print("Score: " .. tempPlayer.score, font, 
					getTextCenter(font, "Score: " .. tempPlayer.score), textHeight-30)
	tempFloor:draw()
end

function love.update(dt)
	if tempPlayer:hitFloor(tempFloor) then
		tempPlayer.alive = false
		tempPlayer.y = tempFloor.y - tempPlayer.height
	elseif tempPlayer.alive then
		tempPlayer:update(dt)
		drawPipes(pipes, dt)
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

	pipes = {}
	table.insert(pipes, Pipe(love.graphics:getWidth(), 0, tempFloor.y))
end

function getTextCenter(font, text)
	return windowWidth/2 - font:getWidth(text)/2
end

function drawPipes(pipeTable, dt)
	for i, pipe in ipairs(pipeTable) do
		if tempPlayer:hitPipe(pipe) then
			tempPlayer.alive = false
			pipe:resolvePlayerCollision(tempPlayer)
			break
		end
		if tempPlayer.alive then
			pipe:update(dt)
			pipe:updateScore(tempPlayer)
			if pipe:reachedEnd() and not pipe.passedFront then
				table.insert(pipeTable, Pipe(love.graphics:getWidth(), 0, tempFloor.y))
				pipe.passedFront = true
			end
			if pipe:passedEnd() then
				table.remove(pipeTable, i)
			end
		end
	end
end