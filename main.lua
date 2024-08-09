function love.load()
	success = love.window.setMode(720, 800)
	love.graphics.setBackgroundColor(173/255, 216/255, 230/255, 1)

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
	pipes = {}
end

function love.draw()
	tempPlayer:draw()
	tempFloor:draw()
	
	for i,pipe in ipairs(pipes) do
		pipe:draw()
	end

	-- print appropriate text
	love.graphics.setColor(0, 0, 0, 1)
	if not gameStarted then
		love.graphics.print(startText, font, textCenterStart, textHeight)
	elseif not tempPlayer.alive then
		love.graphics.print(restartText, font,
			textCenterStart, textHeight)
	else
		love.graphics.print(tempPlayer.score, font, 
							getTextCenter(font, tempPlayer.score), textHeight)
	end
end

function love.update(dt)
	if tempPlayer:hitFloor(tempFloor) then
		tempPlayer.alive = false
		tempPlayer.y = tempFloor.y - tempPlayer.height
	else
		tempPlayer:update(dt)
		drawPipes(pipes, dt)
	end
end

function love.keypressed(key)
	if key == "f2" and not tempPlayer.alive then
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