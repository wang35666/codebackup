local PhysicWorld = class("PhysicWorld")

local function generatorKey(b1, b2)
	if b1.id < b2.id then
		return b1.id * 100 + b2.id
	else
		return b2.id * 100 + b1.id	
	end
end

function PhysicWorld:ctor()
	self.dBodyList = {}
	self.fBodyList = {}
	self.overlapPairCache = {}
	self.numBody = 0
end

function PhysicWorld:addBody(body)
	body.id = self.numBody
	self.numBody = self.numBody + 1
	self.dBodyList[body] = body
end

function PhysicWorld:step()
	for k, body in pairs(self.fBodyList) do
		if body:isActive() then
			self.fBodyList[body] = nil
			self.dBodyList[body] = body
		end
	end

	for k, body in pairs(self.dBodyList) do
		if not body:isActive() then
			self.dBodyList[body] = nil
			self.fBodyList[body] = body
		end
	end

	self:predictUnconstraintMotion()

	self:performCollisionDetection()

	for k, contact in pairs(self.overlapPairCache) do
		self:processContact(contact)
	end

	for k, list in pairs({self.dBodyList, self.fBodyList}) do
		for k, body in pairs(list) do
			body:synchronizePosition()
		end
	end
end

function PhysicWorld:predictUnconstraintMotion()
	for k, body in pairs(self.dBodyList) do
		body:predictMotion(0.16)
	end
end

function PhysicWorld:performCollisionDetection()
	for _, body1 in pairs(self.dBodyList) do
		for _, body2 in pairs(self.fBodyList) do
			self:process(body1, body2)
		end
	end

	for k, body1 in pairs(self.dBodyList) do
		for _, body2 in pairs(self.dBodyList) do
			self:process(body1, body2)
		end
	end
end

function PhysicWorld:process(body1, body2)
	if body1 == body2 then
		return
	end

	local aabb1 = body1:getFatAABB()
	local aabb2 = body2:getFatAABB()

	if aabb1:testOverlap(aabb2) then
		-- print(body1.aabb:__tostring(), aabb1:__tostring(), aabb2:__tostring())
		self:addOverlapPair(body1, body2)
	end
end

function PhysicWorld:addOverlapPair(b1, b2)
	local key = generatorKey(b1, b2)
	if self.overlapPairCache[key] then
		return
	end

	local t = {}
	t.body1 = b1
	t.body2 = b2
	self.overlapPairCache[key] = t
end

function PhysicWorld:processContact( contact )
	local b1 = contact.body1
	local b2 = contact.body2
	
	if not b1:isActive() and not b2:isActive() then
		return
	end 

	if not contact.hasTouching then
		self:beginContact(contact)
		contact.hasTouching = true
	else
		local aabb1 = b1:getFatAABB()
		local aabb2 = b2:getFatAABB()
		local touching = aabb1:testOverlap(aabb2)

		if touching then
			self:preSolve(contact)
		else
			self:endContact(contact)
			local key = generatorKey(contact.body1, contact.body2)
			self.overlapPairCache[key] = nil
		end
	end
end

function PhysicWorld:beginContact(contact)
	print("body", contact.body1.id, contact.body2.id, "beginContact")
	local b1 = contact.body1
	local b2 = contact.body2
	local vx = b1.vel.x - b2.vel.x
	local vy = b1.vel.y - b2.vel.y
	local dx = b1.aabb:distanceX(b2.aabb)
	local dy = b1.aabb:distanceY(b2.aabb)

	local t
	local edgeY = false
	if vx == 0 then
		t = math.abs(dy / vy)
		edgeY = true
	elseif vy == 0 then
		t = math.abs(dx / vx)
		edgeY = false 
	else
		local tx = dx / vx
		local ty = dy / vy
		t = math.min(math.abs(tx), math.abs(ty))
	end

	if edgeY then
		b1:setVel(0, 0)
		b1:setVel(0, 0)
		b1:setPosition()
	end
	print("pos0: ",b1.pos0.y, b2.pos0.y)
	print("v d:", vx, vy, dx, dy)
	print("t: ", t)
	-- b1:setVel(0, 0)
	-- b1:setAcc(0, 0)
end

function PhysicWorld:preSolve(contact)
	print(contact.body1, contact.body2, "preSolve")
end

function PhysicWorld:endContact(contact)
	print(contact.body1, contact.body2, "endContact")
end

return PhysicWorld