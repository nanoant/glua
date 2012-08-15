local ffi  = require 'ffi'
local gl   = require 'glua.gl.gl3'

ffi.cdef [[
typedef struct { double x, y;       } vec2;
typedef struct { double x, y, z;    } vec3;
typedef struct { double x, y, z, w; } vec4;
]]

local glFloatv = ffi.typeof('GLfloat[?]')

local vec2
vec2 = ffi.metatype('vec2', {
  __add = function(a, b) return vec2(a.x + b.x, a.y + b.y) end,
  __sub = function(a, b) return vec2(a.x - b.x, a.y - b.y) end,
  __mul = function(a, b)
    if not ffi.istype(vec2, b) then
    return vec2(a.x * b, a.y * b) end
    return vec2(a.x * b.x, a.y * b.y)
  end,
  __div = function(a, b)
    if not ffi.istype(vec2, b) then
    return vec2(a.x / b, a.y / b) end
    return vec2(a.x / b.x, a.y / b.y)
  end,
  __pow = function(a, b) -- dot product
    if not ffi.istype(vec2, b) then
    return vec2(a.x ^ b, a.y ^ b) end
    return a.x * b.x + a.y * b.y
  end,
  __index = function(v, i)
    if i == 'gl' then return glFloatv(2, v.x, v.y) end
    return nil
  end,
  __tostring = function(v) return '<'..v.x..','..v.y..'>' end
})
local vec3
vec3 = ffi.metatype('vec3', {
  __add = function(a, b) return vec3(a.x + b.x, a.y + b.y, a.z + b.z) end,
  __sub = function(a, b) return vec3(a.x - b.x, a.y - b.y, a.z - b.z) end,
  __mul = function(a, b)
    if not ffi.istype(vec3, b) then
    return vec3(a.x * b, a.y * b, a.z * b) end
    return vec3(a.x * b.x, a.y * b.y, a.z * b.z)
  end,
  __div = function(a, b)
    if not ffi.istype(vec3, b) then
    return vec3(a.x / b, a.y / b, a.z / b) end
    return vec3(a.x / b.x, a.y / b.y, a.z / b.z)
  end,
  __pow = function(a, b) -- dot product
    if not ffi.istype(vec3, b) then
    return vec3(a.x ^ b, a.y ^ b, a.z ^ b) end
    return a.x * b.x + a.y * b.y + a.z * b.z
  end,
  __index = function(v, i)
    if i == 'gl' then return glFloatv(3, v.x, v.y, v.z) end
    return nil
  end,
  __tostring = function(v) return '<'..v.x..','..v.y..','..v.z..'>' end
})
local vec4
vec4 = ffi.metatype('vec4', {
  __add = function(a, b) return vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) end,
  __sub = function(a, b) return vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) end,
  __mul = function(a, b)
    if not ffi.istype(vec4, b) then
    return vec4(a.x * b, a.y * b, a.z * b, a.w * b) end
    return vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
  end,
  __div = function(a, b)
    if not ffi.istype(vec4, b) then
    return vec4(a.x / b, a.y / b, a.z / b, a.w / b) end
    return vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
  end,
  __pow = function(a, b) -- dot product
    if not ffi.istype(vec4, b) then
    return vec4(a.x ^ b, a.y ^ b, a.z ^ b, a.w ^ b) end
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
  end,
  __index = function(v, i)
    if i == 'gl' then return glFloatv(4, v.x, v.y, v.z, v.w) end
    return nil
  end,
  __tostring = function(v) return '<'..v.x..','..v.y..','..v.z..','..v.w..'>' end
})

return {vec2 = vec2, vec3 = vec3, vec4 = vec4, vec = vec4,
        vvec2 = ffi.typeof('vec2[?]'),
        vvec3 = ffi.typeof('vec3[?]'),
        vvec4 = ffi.typeof('vec4[?]'),
        vvec  = ffi.typeof('vec4[?]')}
