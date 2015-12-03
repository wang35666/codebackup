local AABB = class("AABB")

local function testOverlap(b1, b2)
	local dx1 = b1.minx - b2.maxx
	local dy1 = b1.miny - b2.maxy
	local dx2 = b2.minx - b1.maxx
	local dy2 = b2.miny - b1.maxy

	if dx1 > 0 or dy1 > 0 or dx2 > 0 or dy2 > 0 then
		return false
	end
	-- print("testOverlap", dx1, dy1, dx2, dy2)
	return true
end

local function distanceX(b1, b2)
	local d1 = b1.minx - b2.maxx
	local d2 = b2.minx - b1.maxx

	if d1 > 0 then
		return d1
	end

	if d2 > 0 then
		return -d2
	end
	return 0
end

local function distanceY(b1, b2)
	-- print("distanceY", b1.miny, b1.maxy, b2.miny, b2.maxy)
	local d1 = b1.miny - b2.maxy
	local d2 = b2.miny - b1.maxy

	if d1 > 0 then
		return d1
	end

	if d2 > 0 then
		return -d2
	end
	return 0
end

function AABB:ctor(minx, miny, maxx, maxy)
	self:set(minx, miny, maxx, maxy)
end

function AABB:__tostring()
	return string.format("AABB: %.3f %.3f %.3f %.3f", self.minx, self.miny, self.maxx, self.maxy)
end

function AABB:set(minx, miny, maxx, maxy)
	self.minx = minx
	self.miny = miny
	self.maxx = maxx
	self.maxy = maxy
end

function AABB:clone()
	return AABB:create(self.minx, self.miny, self.maxx, self.maxy)
end

function AABB:testOverlap( b )
	return testOverlap(self, b)
end

function AABB:extend(dx, dy)
	if dx < 0 then
		self.minx = self.minx + dx
	else
		self.maxx = self.maxx + dx
	end

	if dy < 0 then
		self.miny = self.miny + dy
	else
		self.maxy = self.maxy + dy
	end
end

function AABB:move(dx, dy)
	self.minx = self.minx + dx
	self.maxx = self.maxx + dx
	self.miny = self.miny + dy
	self.maxy = self.maxy + dy
end

function AABB:assign(b)
	self.minx = b.minx
	self.miny = b.miny
	self.maxx = b.maxx
	self.maxy = b.maxy
end

function AABB:toVerts()
	-- print(self.minx, self.miny, self.maxx, self.maxy)
	return { cc.p(self.minx, self.miny), cc.p(self.maxx, self.miny), cc.p(self.maxx, self.maxy), cc.p(self.minx, self.maxy)}
end

function AABB:distanceX(b)
	return distanceX(self, b)
end

function AABB:distanceY(b)
	return distanceY(self, b)
end


return AABB