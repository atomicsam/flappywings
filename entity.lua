Entity = Object:extend()

function Entity:new(x, y)
	self.x = x
	self.y = y

	self.gravity = 0
	self.weight = 400
end