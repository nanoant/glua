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
  struct {
    GLfloat a, b, c, d;
  };
  GLfloat gl[4];
} GLmat2;
typedef union {
  struct {
    GLfloat m11, m21, m31;
    GLfloat m12, m22, m32;
    GLfloat m13, m23, m33;
  };
  struct {
    GLfloat a, b, c, d, e, f, g, h, k;
  };
  GLfloat gl[9];
} GLmat3;
typedef union {
  struct {
    GLfloat m11, m21, m31, m41;
    GLfloat m12, m22, m32, m42;
    GLfloat m13, m23, m33, m43;
    GLfloat m14, m24, m34, m44;
  };
  struct {
    GLfloat a, b, c, d;
    GLfloat e, f, g, h;
    GLfloat i, j, k, l;
    GLfloat m, n, o, p;
  };
  GLfloat gl[16];
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
  __index = function(m, i)
    if i == 't' then
      return mat2(m.m11, m.m12,
                  m.m21, m.m22)
    elseif i == 'det' then
      return m.a * m.d - m.b * m.c
    elseif i == 'inv' then
      local det = m.a * m.d - m.b * m.c;
      return mat2( m.d / det, -m.b / det,
                  -m.c / det,  m.a / det)
    end
    return nil
  end,
  __tostring = function(m) return string.format("[%2.12g %2.12g]\n[%2.12g %2.12g]", m.a, m.b, m.c, m.d) end
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
  __index = function(m, i)
    if i == 'mat2' then
      return mat2(m.m11, m.m21,
                  m.m12, m.m22)
    elseif i == 't' then
      return mat3(m.m11, m.m12, m.m13,
                  m.m21, m.m22, m.m23,
                  m.m31, m.m32, m.m33)
    elseif i == 'det' then
      return m.a * (m.e*m.k - m.f*m.h) +
             m.b * (m.f*m.g - m.k*m.d) +
             m.c * (m.d*m.h - m.e*m.g)
    elseif i == 'inv' then
      local det = m.a * (m.e*m.k - m.f*m.h) +
                  m.b * (m.f*m.g - m.k*m.d) +
                  m.c * (m.d*m.h - m.e*m.g)
      return mat3((m.e*m.k - m.f*m.h) / det, (m.c*m.h - m.b*m.k) / det, (m.b*m.f - m.c*m.e) / det,
                  (m.f*m.g - m.d*m.k) / det, (m.a*m.k - m.c*m.g) / det, (m.c*m.d - m.a*m.f) / det,
                  (m.d*m.h - m.e*m.g) / det, (m.g*m.b - m.a*m.h) / det, (m.a*m.e - m.b*m.d) / det)
    end
    return nil
  end,
  __tostring = function(m)
    return string.format("[%2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g]",
                         m.a, m.b, m.c, m.d, m.e, m.f, m.g, m.h, m.k)
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
  __index = function(m, i)
    if i == 'mat3' then
      return mat3(m.m11, m.m21, m.m31,
                  m.m12, m.m22, m.m32,
                  m.m13, m.m23, m.m33)
    elseif i == 'mat2' then
      return mat2(m.m11, m.m21,
                  m.m12, m.m22)
    elseif i == 't' then
      return mat4(m.m11, m.m12, m.m13, m.m14,
                  m.m21, m.m22, m.m23, m.m24,
                  m.m31, m.m32, m.m33, m.m34,
                  m.m41, m.m42, m.m43, m.m44)
     -- http://stackoverflow.com/questions/1148309/inverting-a-4x4-matrix
    elseif i == 'det' then
      local i1 =  m.f*m.k*m.p - m.f*m.l*m.o - m.j*m.g*m.p + m.j*m.h*m.o + m.n*m.g*m.l - m.n*m.h*m.k
      local i2 = -m.e*m.k*m.p + m.e*m.l*m.o + m.i*m.g*m.p - m.i*m.h*m.o - m.m*m.g*m.l + m.m*m.h*m.k
      local i3 =  m.e*m.j*m.p - m.e*m.l*m.n - m.i*m.f*m.p + m.i*m.h*m.n + m.m*m.f*m.l - m.m*m.h*m.j
      local i4 = -m.e*m.j*m.o + m.e*m.k*m.n + m.i*m.f*m.o - m.i*m.g*m.n - m.m*m.f*m.k + m.m*m.g*m.j
      return m.a*i1 + m.b*i2 + m.c*i3 + m.d*i4
    elseif i == 'inv' then
      local inv = mat4(
        m.f*m.k*m.p - m.f*m.l*m.o - m.j*m.g*m.p + m.j*m.h*m.o + m.n*m.g*m.l - m.n*m.h*m.k,
       -m.b*m.k*m.p + m.b*m.l*m.o + m.j*m.c*m.p - m.j*m.d*m.o - m.n*m.c*m.l + m.n*m.d*m.k,
        m.b*m.g*m.p - m.b*m.h*m.o - m.f*m.c*m.p + m.f*m.d*m.o + m.n*m.c*m.h - m.n*m.d*m.g,
       -m.b*m.g*m.l + m.b*m.h*m.k + m.f*m.c*m.l - m.f*m.d*m.k - m.j*m.c*m.h + m.j*m.d*m.g,
       -m.e*m.k*m.p + m.e*m.l*m.o + m.i*m.g*m.p - m.i*m.h*m.o - m.m*m.g*m.l + m.m*m.h*m.k,
        m.a*m.k*m.p - m.a*m.l*m.o - m.i*m.c*m.p + m.i*m.d*m.o + m.m*m.c*m.l - m.m*m.d*m.k,
       -m.a*m.g*m.p + m.a*m.h*m.o + m.e*m.c*m.p - m.e*m.d*m.o - m.m*m.c*m.h + m.m*m.d*m.g,
        m.a*m.g*m.l - m.a*m.h*m.k - m.e*m.c*m.l + m.e*m.d*m.k + m.i*m.c*m.h - m.i*m.d*m.g,
        m.e*m.j*m.p - m.e*m.l*m.n - m.i*m.f*m.p + m.i*m.h*m.n + m.m*m.f*m.l - m.m*m.h*m.j,
       -m.a*m.j*m.p + m.a*m.l*m.n + m.i*m.b*m.p - m.i*m.d*m.n - m.m*m.b*m.l + m.m*m.d*m.j,
        m.a*m.f*m.p - m.a*m.h*m.n - m.e*m.b*m.p + m.e*m.d*m.n + m.m*m.b*m.h - m.m*m.d*m.f,
       -m.a*m.f*m.l + m.a*m.h*m.j + m.e*m.b*m.l - m.e*m.d*m.j - m.i*m.b*m.h + m.i*m.d*m.f,
       -m.e*m.j*m.o + m.e*m.k*m.n + m.i*m.f*m.o - m.i*m.g*m.n - m.m*m.f*m.k + m.m*m.g*m.j,
        m.a*m.j*m.o - m.a*m.k*m.n - m.i*m.b*m.o + m.i*m.c*m.n + m.m*m.b*m.k - m.m*m.c*m.j,
       -m.a*m.f*m.o + m.a*m.g*m.n + m.e*m.b*m.o - m.e*m.c*m.n - m.m*m.b*m.g + m.m*m.c*m.f,
        m.a*m.f*m.k - m.a*m.g*m.j - m.e*m.b*m.k + m.e*m.c*m.j + m.i*m.b*m.g - m.i*m.c*m.f)
       local det = m.a*inv.a + m.b*inv.e + m.c*inv.i + m.d*inv.m
       inv.a = inv.a / det; inv.b = inv.b / det; inv.c = inv.c / det; inv.d = inv.d / det
       inv.e = inv.e / det; inv.f = inv.f / det; inv.g = inv.g / det; inv.h = inv.h / det
       inv.i = inv.i / det; inv.j = inv.j / det; inv.k = inv.k / det; inv.l = inv.l / det
       inv.m = inv.m / det; inv.n = inv.n / det; inv.o = inv.o / det; inv.p = inv.p / det
       return inv
    end
    return nil
  end,
  __tostring = function(m)
    return string.format("[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]\n[%2.12g %2.12g %2.12g %2.12g]",
                         m.a, m.b, m.c, m.d, m.e, m.f, m.g, m.h, m.i, m.j, m.k, m.l, m.m, m.n, m.o, m.p)
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
M.mat  = mat4
M.Rotate2  = glRotate2
M.Rotate3x = glRotate3x
M.Rotate3y = glRotate3y
M.Rotate3z = glRotate3z
M.Rotate3  = glRotate3
M.Rotate4x = glRotate4x
M.Rotate4y = glRotate4y
M.Rotate4z = glRotate4z
M.Rotate4  = glRotate4
M.Rotatex  = glRotate4x
M.Rotatey  = glRotate4y
M.Rotatez  = glRotate4z
M.Rotate   = glRotate4
M.identity2 = mat2(1, 0,
                   0, 1)
M.identity3 = mat3(1, 0, 0,
                   0, 1, 0,
                   0, 0, 1)
M.identity4 = mat4(1, 0, 0, 0,
                   0, 1, 0, 0,
                   0, 0, 1, 0,
                   0, 0, 0, 1)
M.identity = M.identity4

function M.Translate(x, y, z)
  if ffi.istype(vec2, x) then
    y = x.y
    x = x.x
  elseif ffi.istype(vec3, x) then
    z = x.z
    y = x.y
    x = x.x
  end
  y = y or 0
  z = z or 0
  return mat4(1, 0, 0, x,
              0, 1, 0, y,
              0, 0, 1, z,
              0, 0, 0, 1)
end

function M.Frustum(l, r, b, t, n, f)
  return mat4(2*n/(r-l),         0,  (r+l)/(r-l),            0,
                      0, 2*n/(t-b),  (t+b)/(t-b),            0,
                      0,         0, -(f+n)/(f-n), -2*n*f/(f-n),
                      0,         0,           -1,            0)
end
function M.Perspective(fovy, aspect, n, f)
   local t = n * math.tan(fovy * math.pi / 360.0)
   local r = t * aspect
   return M.Frustum(-r, r, -t, t, n, f)
end
function M.Ortho(l, r, b, t, n, f)
  return mat4(2/(r-l),       0,        0, -(r+l)/(r-l),
                    0, 2/(t-b),        0, -(t+b)/(t-b),
                    0,       0, -2/(f-n), -(f+n)/(f-n),
                    0,       0,        0,            1)
end

return M
