local ffi  = require 'ffi'
local gl   = require 'gl.gl3'

ffi.cdef [[
typedef union {
  struct { GLfloat x, y; };
  struct { GLfloat r, g; };
  struct { GLfloat s, t; };
  struct { GLfloat gl[2]; };
} GLvec2;
typedef union {
  struct { GLfloat x, y, z; };
  struct { GLfloat r, g, b; };
  struct { GLfloat s, t, p; };
  struct { GLfloat gl[3]; };
} GLvec3;
typedef union {
  struct { GLfloat x, y, z, w; };
  struct { GLfloat r, g, b, a; };
  struct { GLfloat s, t, p, q; };
  struct { GLfloat gl[4]; };
} GLvec4;
]]

local vec2
vec2 = ffi.metatype('GLvec2', {
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
  __tostring = function(a) return '<'..a.x..','..a.y..'>' end
})
local vec3
vec3 = ffi.metatype('GLvec3', {
  __add = function(a, b) return vec2(a.x + b.x, a.y + b.y, a.z + b.z) end,
  __sub = function(a, b) return vec2(a.x - b.x, a.y - b.y, a.z - b.z) end,
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
  __tostring = function(a) return '<'..a.x..','..a.y..','..a.z..'>' end
})
local vec4
vec4 = ffi.metatype('GLvec4', {
  __add = function(a, b) return vec2(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) end,
  __sub = function(a, b) return vec2(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) end,
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
  __tostring = function(a) return '<'..a.x..','..a.y..','..a.z..','..a.w..'>' end
})

return {vec2 = vec2, vec3 = vec3, vec4 = vec4, vec = vec4,
        vvec2 = ffi.typeof('GLvec2[?]'),
        vvec3 = ffi.typeof('GLvec3[?]'),
        vvec4 = ffi.typeof('GLvec4[?]'),
        vvec  = ffi.typeof('GLvec4[?]')}
