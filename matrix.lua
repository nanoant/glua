local ffi  = require 'ffi'
local gl   = require 'gl.gl3'
local math = require 'math'
local sin, cos = math.sin, math.cos

ffi.cdef [[
typedef union {
  struct {
    GLfloat m11, m21;
    GLfloat m12, m22;
  };
  GLfloat data[4];
} GLmat2;
typedef union {
  struct {
    GLfloat m11, m21, m31;
    GLfloat m12, m22, m32;
    GLfloat m13, m23, m33;
  };
  GLfloat data[9];
} GLmat3;
typedef union {
  struct {
    GLfloat m11, m21, m31, m41;
    GLfloat m12, m22, m32, m42;
    GLfloat m13, m23, m33, m43;
    GLfloat m14, m24, m34, m44;
  };
  GLfloat data[16];
} GLmat4;
]]

local M = require 'vector'

local vec2, vec3, vec4 = M.vec2, M.vec3, M.vec4

local mat2
mat2 = ffi.metatype('GLmat2', {
  __mul = function(a, b)
    if not ffi.istype(mat2, b) then
      return vec2(a.m11*b.x + a.m21*b.y,
                  a.m12*b.x + a.m22*b.y)
    end
    return mat2(a.m11*b.m11 + a.m21*b.m12,  a.m11*b.m21 + a.m21*b.m22,
                a.m12*b.m11 + a.m22*b.m12,  a.m12*b.m21 + a.m22*b.m22)
  end,
  __tostring = function(a) return string.format("[%2.12g %2.12g]\n[%2.12g %2.12g]", a.m11, a.m21, a.m12, a.m22) end
})
local mat3
mat3 = ffi.metatype('GLmat3', {
  __mul = function(a, b)
    if not ffi.istype(mat3, b) then
      return vec3(a.m11*b.x + a.m21*b.y + a.m31*b.z,
                  a.m12*b.x + a.m22*b.y + a.m32*b.z,
                  a.m13*b.x + a.m23*b.y + a.m33*b.z)
    end
    return mat3(a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13,  a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23,  a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33,
                a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13,  a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23,  a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33,
                a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13,  a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23,  a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33)
  end,
  __tostring = function(a)
    return string.format("[%2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g]",
                         a.m11, a.m21, a.m31,
                         a.m12, a.m22, a.m32,
                         a.m13, a.m23, a.m33)
    end
})
local mat4
mat4 = ffi.metatype('GLmat4', {
  __mul = function(a, b)
    if not ffi.istype(mat4, b) then
      return vec4(a.m11*b.x + a.m21*b.y + a.m31*b.z + a.m41*b.w,
                  a.m12*b.x + a.m22*b.y + a.m32*b.z + a.m42*b.w,
                  a.m13*b.x + a.m23*b.y + a.m33*b.z + a.m43*b.w,
                  a.m14*b.x + a.m24*b.y + a.m34*b.z + a.m44*b.w)
    end
    return mat4(a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13 + a.m41*b.m14,
                a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23 + a.m41*b.m24,
                a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33 + a.m41*b.m34,
                a.m11*b.m41 + a.m21*b.m42 + a.m31*b.m43 + a.m41*b.m44,

                a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13 + a.m42*b.m14,
                a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23 + a.m42*b.m24,
                a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33 + a.m42*b.m34,
                a.m12*b.m41 + a.m22*b.m42 + a.m32*b.m43 + a.m42*b.m44,

                a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13 + a.m43*b.m14,
                a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23 + a.m43*b.m24,
                a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33 + a.m43*b.m34,
                a.m13*b.m41 + a.m23*b.m42 + a.m33*b.m43 + a.m43*b.m44,

                a.m14*b.m11 + a.m24*b.m12 + a.m34*b.m13 + a.m44*b.m14,
                a.m14*b.m21 + a.m24*b.m22 + a.m34*b.m23 + a.m44*b.m24,
                a.m14*b.m31 + a.m24*b.m32 + a.m34*b.m33 + a.m44*b.m34,
                a.m14*b.m41 + a.m24*b.m42 + a.m34*b.m43 + a.m44*b.m44)
  end,
  __tostring = function(a)
    return string.format("[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]",
                         a.m11, a.m21, a.m31, a.m41,
                         a.m12, a.m22, a.m32, a.m42,
                         a.m13, a.m23, a.m33, a.m43,
                         a.m14, a.m24, a.m34, a.m44)
    end
})

local function glRotate2(r)
  return mat2(cos(r), -sin(r),
              sin(r),  cos(r))
end
local function glRotate3x(r)
  return mat3(1,     0,       0,
              0, cos(r), -sin(r),
              0, sin(r),  cos(r))
end
local function glRotate3y(r)
  return mat3(cos(r), 0, sin(r),
                   0, 1,      0,
             -sin(r), 0, cos(r))
end
local function glRotate3z(r)
  return mat3(cos(r), -sin(r), 0,
              sin(r),  cos(r), 0,
                   0,       0, 1)
end
local function glRotate3(rx, ry, rz)
  return glRotate3x(rx) * glRotate3y(ry) * glRotate3z(rz)
end
local function glRotate4x(r)
  return mat4(1,     0,        0, 0,
              0, cos(r), -sin(r), 0,
              0, sin(r),  cos(r), 0,
              0,      0,       0, 1)
end
local function glRotate4y(r)
  return mat4(cos(r), 0, sin(r), 0,
                   0, 1,      0, 0,
             -sin(r), 0, cos(r), 0,
                   0, 0,      0, 1)
end
local function glRotate4z(r)
  return mat4(cos(r), -sin(r), 0, 0,
              sin(r),  cos(r), 0, 0,
                   0,       0, 1, 0,
                   0,       0, 0, 1)
end
local function glRotate4(rx, ry, rz)
  return glRotate4x(rx) * glRotate4y(ry) * glRotate4z(rz)
end

M.mat2 = mat2
M.mat3 = mat3
M.mat4 = mat4
M.Rotate2  = glRotate2
M.Rotate3x = glRotate3x
M.Rotate3y = glRotate3y
M.Rotate3z = glRotate3z
M.Rotate3  = glRotate3
M.Rotate4x = glRotate4x
M.Rotate4y = glRotate4y
M.Rotate4z = glRotate4z
M.Rotate4  = glRotate4

return M
