function love.load()
	success = love.window.setMode(720, 800)
	love.graphics.setBackgroundColor(173/255, 216/255, 230/255, 1)

	Object = require "classic"
	require "entity"
	require "player"
	require "pipe"
	require "score"
	require "floor"
	require "sky"

	tempFloor = Floor()
	tempPlayer = Player(100, 100)

	pipes = {}
	table.insert(pipes, Pipe(300, 0, tempFloor.y))
end

function love.draw()
	tempPlayer:draw()
	tempFloor:draw()
	
	for i,pipe in ipairs(pipes) do
		pipe:draw()
	end
end

function love.update(dt)
	tempPlayer:update(dt)
	for i, pipe in ipairs(pipes) do
		pipe:update(dt)
	end
end