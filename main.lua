function love.load()
	success = love.window.setMode(720, 1280)
	love.graphics.setBackgroundColor(173/255, 216/255, 230/255, 1)

	Object = require "classic"
	require "entity"
	require "player"
	require "pipe"
	require "score"
	require "floor"
	require "sky"

	tempPlayer = Player(100, 100)
	tempFloor = Floor(0, 880)
end

function love.draw()
	tempPlayer:draw()
	tempFloor:draw()
end

function love.update(dt)
	tempPlayer:update(dt)
end