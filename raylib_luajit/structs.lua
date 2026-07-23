-- structs and operators

-- Vector2
local Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, self)
end

Vector2.Zero = Vector2:new(0, 0)
Vector2.Ones = Vector2:new(1, 1)
Vector2.UnitX = Vector2:new(1, 0)
Vector2.UnitY = Vector2:new(0, 1)

function Vector2.add(a, b)
    return Vector2:new(a.x + b.x, a.y + b.y)
end

function Vector2.subtract(a, b)
    return Vector2:new(a.x - b.x, a.y - b.y)
end

function Vector2.scale(a, s)
    return Vector2:new(a.x * s, a.y * s)
end

function Vector2.multiply(a, b)
    if type(b) == "number" then
        return Vector2:new(a.x * b, a.y * b)
    else
        return Vector2:new(a.x * b.x, a.y * b.y)
    end
end

function Vector2.divide(a, b)
    if type(b) == "number" then
        return Vector2:new(a.x / b, a.y / b)
    else
        return Vector2:new(a.x / b.x, a.y / b.y)
    end
end

function Vector2.__add(a, b)
    return Vector2.add(a, b)
end

function Vector2.__sub(a, b)
    return Vector2.subtract(a, b)
end

function Vector2.__mul(a, b)
    return Vector2.multiply(a, b)
end

function Vector2.__div(a, b)
    return Vector2.divide(a, b)
end

function Vector2.__eq(a, b)
    local epsilon = 1e-6
    return math.abs(a.x - b.x) < epsilon and
           math.abs(a.y - b.y) < epsilon
end

function Vector2.__tostring(v)
    return string.format("Vector2(%.2f, %.2f)", v.x, v.y)
end

function Vector2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:normalize()
    local len = self:length()
    if len > 0 then
        return Vector2:new(self.x / len, self.y / len)
    end
    return Vector2:new()
end

-- Vector3
local Vector3 = {}
Vector3.__index = Vector3

function Vector3:new(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0
    }, self)
end

Vector3.Zero = Vector3:new(0, 0, 0)
Vector3.Ones = Vector3:new(1, 1, 1)
Vector3.UnitX = Vector3:new(1, 0, 0)
Vector3.UnitY = Vector3:new(0, 1, 0)
Vector3.UnitZ = Vector3:new(0, 0, 1)

function Vector3.add(a, b)
    return Vector3:new(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vector3.subtract(a, b)
    return Vector3:new(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector3.multiply(a, b)
    if type(b) == "number" then
        return Vector3:new(a.x * b, a.y * b, a.z * b)
    else
        return Vector3:new(a.x * b.x, a.y * b.y, a.z * b.z)
    end
end

function Vector3.divide(a, b)
    if type(b) == "number" then
        return Vector3:new(a.x / b, a.y / b, a.z / b)
    else
        return Vector3:new(a.x / b.x, a.y / b.y, a.z / b.z)
    end
end

function Vector3.__add(a, b)
    return Vector3.add(a, b)
end

function Vector3.__sub(a, b)
    return Vector3.subtract(a, b)
end

function Vector3.__mul(a, b)
    return Vector3.multiply(a, b)
end

function Vector3.__div(a, b)
    return Vector3.divide(a, b)
end

function Vector3.__eq(a, b)
    local epsilon = 1e-6
    return math.abs(a.x - b.x) < epsilon and
           math.abs(a.y - b.y) < epsilon and
           math.abs(a.z - b.z) < epsilon
end

function Vector3.__tostring(v)
    return string.format("Vector3(%.2f, %.2f, %.2f)", v.x, v.y, v.z)
end

function Vector3:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:normalize()
    local len = self:length()
    if len > 0 then
        return Vector3:new(self.x / len, self.y / len, self.z / len)
    end
    return Vector3:new()
end

function Vector3:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vector3:cross(other)
    return Vector3:new(
        self.y * other.z - self.z * other.y,
        self.z * other.x - self.x * other.z,
        self.x * other.y - self.y * other.x
    )
end


-- Vector4
local Vector4 = {}
Vector4.__index = Vector4

function Vector4:new(x, y, z, w)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0,
        w = w or 0
    }, self)
end

Vector4.Zero = Vector4:new(0, 0, 0, 0)
Vector4.Ones = Vector4:new(1, 1, 1, 1)
Vector4.UnitX = Vector4:new(1, 0, 0, 0)
Vector4.UnitY = Vector4:new(0, 1, 0, 0)
Vector4.UnitZ = Vector4:new(0, 0, 1, 0)
Vector4.UnitW = Vector4:new(0, 0, 0, 1)

function Vector4.add(a, b)
    return Vector4:new(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
end

function Vector4.subtract(a, b)
    return Vector4:new(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
end

function Vector4.scale(a, s)
    return Vector4:new(a.x * s, a.y * s, a.z * s, a.w * s)
end

function Vector4.multiply(a, b)
    if type(b) == "number" then
        return Vector4:new(a.x * b, a.y * b, a.z * b, a.w * b)
    else
        return Vector4:new(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
    end
end

function Vector4.divide(a, b)
    if type(b) == "number" then
        return Vector4:new(a.x / b, a.y / b, a.z / b, a.w / b)
    else
        return Vector4:new(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
    end
end

function Vector4.__add(a, b)
    return Vector4.add(a, b)
end

function Vector4.__sub(a, b)
    return Vector4.subtract(a, b)
end

function Vector4.__mul(a, b)
    return Vector4.multiply(a, b)
end

function Vector4.__div(a, b)
    return Vector4.divide(a, b)
end

function Vector4.__eq(a, b)
    local epsilon = 1e-6
    return math.abs(a.x - b.x) < epsilon and
           math.abs(a.y - b.y) < epsilon and
           math.abs(a.z - b.z) < epsilon and
           math.abs(a.w - b.w) < epsilon
end

function Vector4.__tostring(v)
    return string.format("Vector4(%.2f, %.2f, %.2f, %.2f)", v.x, v.y, v.z, v.w)
end

function Vector4:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w)
end

function Vector4:normalize()
    local len = self:length()
    if len > 0 then
        return Vector4:new(self.x / len, self.y / len, self.z / len, self.w / len)
    end
    return Vector4:new()
end


-- Quaternion (typedef of Vector4)
local Quaternion = setmetatable({}, {
    __index = Vector4,
    __newindex = Vector4
})

Quaternion.Zero = Vector4.Zero
Quaternion.Ones = Vector4.Ones
Quaternion.UnitX = Vector4.UnitX
Quaternion.UnitY = Vector4.UnitY
Quaternion.UnitZ = Vector4.UnitZ
Quaternion.UnitW = Vector4.UnitW

setmetatable(Quaternion, {
    __call = function(_, x, y, z, w)
        return Vector4:new(x, y, z, w)
    end
})

return {
    Vector2 = Vector2,
    Vector3 = Vector3,
    Vector4 = Vector4,
    Quaternion = Quaternion
}