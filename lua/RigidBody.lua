local AABB = require("app.AABB")
local RigidBody = class("RigidBody")

function RigidBody:ctor(posx, posy)
	self.id = 0
	self.pos0 	= cc.p(posx, posy)
	self.pos1 	= cc.p(posx, posy)
	self.acc 	= cc.p(0, 0)
	self.vel 	= cc.p(0, 0)

	self.isPosChanged = false
	self.aabb = AABB:create(-40, -40, 40, 40)
	self.aabb:move(posx, posy)
	self.fataabb = AABB:create(0, 0, 0, 0)
	self.fataabb:assign(self.aabb)
end

function RigidBody:attach(node)
	local draw = cc.DrawNode:create()
    node:addChild(draw, 10)
    
    --draw open random color poly
   	draw:drawPoly( self.aabb:toVerts(), 4, true, cc.c4f(1, 0, 0, 1))
    self.draw = draw
end

function RigidBody:__tostring()
	return "body "..self.id
end

function RigidBody:setVel(x, y)
	self.vel.x = x
	self.vel.y = y
	self:acitvate()
end

function RigidBody:setAcc(x, y)
	self.acc.x = x
	self.acc.y = y
	self:acitvate()
end

function RigidBody:setPosition(x, y)
	if self.pos0.x ~= x or self.pos0.y ~= y then
		self.pos1.x = x
		self.pos1.y = y
		self.isPosChanged = true
	end
end

function RigidBody:isActive()
	return self._isActive
end

function RigidBody:acitvate()
	self._isActive = self.vel.x ~= 0 or self.vel.y ~= 0 or self.acc.x ~= 0 or self.acc.y ~= 0
end

function RigidBody:predictMotion(dt)
	if not self._isActive then
		return
	end

	self.vel.x = self.vel.x + self.acc.x * dt
	self.vel.y = self.vel.y + self.acc.y * dt
	local dx = self.vel.x * dt
	local dy = self.vel.y * dt
	self.pos1.x = self.pos1.x + dx
	self.pos1.y = self.pos1.y + dy

	self.fataabb:assign(self.aabb)
	self.fataabb:extend(dx, dy)
	self.isPosChanged = true
end

function RigidBody:synchronizePosition()
	if self.isPosChanged then
		local dx = self.pos1.x - self.pos0.x
		local dy = self.pos1.y - self.pos0.y
		self.aabb:move(dx, dy)
		self.pos0.x = self.pos1.x
		self.pos0.y = self.pos1.y
		-- print(self.pos0.y, self.aabb.miny)

		if self.draw then
			self.draw:clear()
			self.draw:drawPoly( self.aabb:toVerts(), 4, true, cc.c4f(1, 0, 0, 1))
		end
		self.isPosChanged = false
	end
end

function RigidBody:getFatAABB()
	if self._isActive then
		return self.fataabb
	end
	return self.aabb
end

return RigidBody