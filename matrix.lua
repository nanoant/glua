local ffi  = require 'ffi'
local gl   = require 'gl.gl3'
local math = require 'math'
local bit  = require 'bit'
local sin, cos = math.sin, math.cos

ffi.cdef [[
typedef struct {
  GLfloat m11, m21;
  GLfloat m12, m22;
} GLmat2;
typedef struct {
  GLfloat m11, m21, m31;
  GLfloat m12, m22, m32;
  GLfloat m13, m23, m33;
} GLmat3;
typedef struct {
  GLfloat m11, m21, m31, m41;
  GLfloat m12, m22, m32, m42;
  GLfloat m13, m23, m33, m43;
  GLfloat m14, m24, m34, m44;
} GLmat4;
]]

local M = require 'vector'

local vec2, vec3, vec4 = M.vec2, M.vec3, M.vec4
local glFloatp = ffi.typeof('GLfloat *')

local mat2
mat2 = ffi.metatype('GLmat2', {
  __mul = function(a, b)
    if not ffi.istype(mat2, a) then a, b = b, a end
    if ffi.istype(mat2, b) then
      return mat2(a.m11*b.m11 + a.m21*b.m12,  a.m11*b.m21 + a.m21*b.m22,
                  a.m12*b.m11 + a.m22*b.m12,  a.m12*b.m21 + a.m22*b.m22)
    elseif ffi.istype(vec2, b) then
      return vec2(a.m11*b.x + a.m21*b.y,
                  a.m12*b.x + a.m22*b.y)
    end
    return mat2(a.m11 * b, a.m21 * b,
                a.m12 * b, a.m22 * b)
  end,
  __index = function(m, i)
    if i == 't' then
      return mat2(m.m11, m.m12,
                  m.m21, m.m22)
    elseif i == 'det' then
      return m.m11 * m.m22 - m.m21 * m.m12
    elseif i == 'inv' then
      local det = m.m11 * m.m22 - m.m21 * m.m12;
      return mat2( m.m22 / det, -m.m21 / det,
                  -m.m12 / det,  m.m11 / det)
    elseif i == 'gl' then
      return ffi.cast(glFloatp, m)
    end
    return nil
  end,
  __tostring = function(m) return string.format("[%4.1f %4.1f ]\n[%4.1f %4.1f ]",
                                                  m.m11, m.m21,   m.m12, m.m22) end
})
local mat3
mat3 = ffi.metatype('GLmat3', {
  __mul = function(a, b)
    if not ffi.istype(mat3, a) then a, b = b, a end
    if ffi.istype(mat3, b) then
      return mat3(a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13,  a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23,  a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33,
                  a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13,  a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23,  a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33,
                  a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13,  a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23,  a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33)
    elseif ffi.istype(vec3, b) then
      return vec3(a.m11*b.x + a.m21*b.y + a.m31*b.z,
                  a.m12*b.x + a.m22*b.y + a.m32*b.z,
                  a.m13*b.x + a.m23*b.y + a.m33*b.z)
    end
    return mat3(a.m11 * b, a.m21 * b, a.m31 * b,
                a.m12 * b, a.m22 * b, a.m32 * b,
                a.m13 * b, a.m23 * b, a.m33 * b)
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
      return m.m11 * (m.m22*m.m33 - m.m32*m.m23) +
             m.m21 * (m.m32*m.m13 - m.m33*m.m12) +
             m.m31 * (m.m12*m.m23 - m.m22*m.m13)
    elseif i == 'inv' then
      local det = m.m11 * (m.m22*m.m33 - m.m32*m.m23) +
                  m.m21 * (m.m32*m.m13 - m.m33*m.m12) +
                  m.m31 * (m.m12*m.m23 - m.m22*m.m13)
      return mat3((m.m22*m.m33 - m.m32*m.m23) / det, (m.m31*m.m23 - m.m21*m.m33) / det, (m.m21*m.m32 - m.m31*m.m22) / det,
                  (m.m32*m.m13 - m.m12*m.m33) / det, (m.m11*m.m33 - m.m31*m.m13) / det, (m.m31*m.m12 - m.m11*m.m32) / det,
                  (m.m12*m.m23 - m.m22*m.m13) / det, (m.m13*m.m21 - m.m11*m.m23) / det, (m.m11*m.m22 - m.m21*m.m12) / det)
    elseif i == 'gl' then
      return ffi.cast(glFloatp, m)
    end
    return nil
  end,
  __tostring = function(m)
    return string.format("[%4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f ]",
                           m.m11, m.m21, m.m31,  m.m12, m.m22, m.m32,  m.m13, m.m23, m.m33)
    end
})
local mat4
mat4 = ffi.metatype('GLmat4', {
  __mul = function(a, b)
    if not ffi.istype(mat4, a) then a, b = b, a end
    if ffi.istype(mat4, b) then
      local ret = mat4()
      local r = ffi.cast(glFloatp, ret)
      local a = ffi.cast(glFloatp, a)
      local b = ffi.cast(glFloatp, b)
      -- NOTE: further unrolling does not bring performance benefit
      for i = 0, 15, 4 do
        -- unrolling:
        -- for j = 0, 3 do
        --   r[i+j] = a[i]*b[j] + a[i+1]*b[j+4] + a[i+2]*b[j+8] + a[i+3]*b[j+12]
        -- end
        r[i]   = a[i]*b[0] + a[i+1]*b[4] + a[i+2]*b[8]  + a[i+3]*b[12]
        r[i+1] = a[i]*b[1] + a[i+1]*b[5] + a[i+2]*b[9]  + a[i+3]*b[13]
        r[i+2] = a[i]*b[2] + a[i+1]*b[6] + a[i+2]*b[10] + a[i+3]*b[14]
        r[i+3] = a[i]*b[3] + a[i+1]*b[7] + a[i+2]*b[11] + a[i+3]*b[15]
      end
      return ret
    elseif ffi.istype(vec4, b) then
      local ret = vec4()
      local r = ffi.cast(glFloatp, ret)
      local a = ffi.cast(glFloatp, a)
      local b = ffi.cast(glFloatp, b)
      -- unrolling:
      -- for i = 0, 3 do
      --   r[i] = b[i]*a[4*i] + b[i+1]*a[4*i+1] + b[i+2]*a[4*i+2] + b[i+3]*a[4*i+3]
      -- end
      r[0] = b[0]*a[0]  + b[1]*a[1]  + b[2]*a[2]  + b[3]*a[3]
      r[1] = b[0]*a[4]  + b[1]*a[5]  + b[2]*a[6]  + b[3]*a[9]
      r[2] = b[0]*a[8]  + b[1]*a[9]  + b[2]*a[10] + b[3]*a[11]
      r[3] = b[0]*a[12] + b[1]*a[13] + b[2]*a[14] + b[3]*a[15]
      return ret
    elseif ffi.istype(vec3, b) then
      local ret = vec3()
      local r = ffi.cast(glFloatp, ret)
      local a = ffi.cast(glFloatp, a)
      local b = ffi.cast(glFloatp, b)
      r[0] = b[0]*a[0]  + b[1]*a[1]  + b[2]*a[2]  + b[3]*a[3]
      r[1] = b[0]*a[4]  + b[1]*a[5]  + b[2]*a[6]  + b[3]*a[9]
      r[2] = b[0]*a[8]  + b[1]*a[9]  + b[2]*a[10] + b[3]*a[11]
      return ret
    end
    local ret = mat4()
    local r = ffi.cast(glFloatp, ret)
    local a = ffi.cast(glFloatp, a)
    -- unrolling:
    -- for i = 0, 15 do r[i] = a[i]*b end
    r[0]  = a[0]*b;  r[1]  = a[1]*b;  r[2]  = a[2]*b;  r[3]  = a[3]*b
    r[4]  = a[4]*b;  r[5]  = a[5]*b;  r[6]  = a[6]*b;  r[7]  = a[7]*b
    r[8]  = a[8]*b;  r[9]  = a[9]*b;  r[10] = a[10]*b; r[11] = a[11]*b
    r[12] = a[12]*b; r[13] = a[13]*b; r[14] = a[14]*b; r[15] = a[15]*b
    return ret
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
      -- NOTE: no performance benefit turning to float *
      return mat4(m.m11, m.m12, m.m13, m.m14,
                  m.m21, m.m22, m.m23, m.m24,
                  m.m31, m.m32, m.m33, m.m34,
                  m.m41, m.m42, m.m43, m.m44)
    -- http://stackoverflow.com/questions/1148309/inverting-a-4x4-matrix
    elseif i == 'det' then
      local i1 =  m.m22*m.m33*m.m44 - m.m22*m.m43*m.m34 - m.m23*m.m32*m.m44 + m.m23*m.m42*m.m34 + m.m24*m.m32*m.m43 - m.m24*m.m42*m.m33
      local i2 = -m.m12*m.m33*m.m44 + m.m12*m.m43*m.m34 + m.m13*m.m32*m.m44 - m.m13*m.m42*m.m34 - m.m14*m.m32*m.m43 + m.m14*m.m42*m.m33
      local i3 =  m.m12*m.m23*m.m44 - m.m12*m.m43*m.m24 - m.m13*m.m22*m.m44 + m.m13*m.m42*m.m24 + m.m14*m.m22*m.m43 - m.m14*m.m42*m.m23
      local i4 = -m.m12*m.m23*m.m34 + m.m12*m.m33*m.m24 + m.m13*m.m22*m.m34 - m.m13*m.m32*m.m24 - m.m14*m.m22*m.m33 + m.m14*m.m32*m.m23
      return m.m11*i1 + m.m21*i2 + m.m31*i3 + m.m41*i4
    elseif i == 'inv' then
      local inv = mat4(
        m.m22*m.m33*m.m44 - m.m22*m.m43*m.m34 - m.m23*m.m32*m.m44 + m.m23*m.m42*m.m34 + m.m24*m.m32*m.m43 - m.m24*m.m42*m.m33,
       -m.m21*m.m33*m.m44 + m.m21*m.m43*m.m34 + m.m23*m.m31*m.m44 - m.m23*m.m41*m.m34 - m.m24*m.m31*m.m43 + m.m24*m.m41*m.m33,
        m.m21*m.m32*m.m44 - m.m21*m.m42*m.m34 - m.m22*m.m31*m.m44 + m.m22*m.m41*m.m34 + m.m24*m.m31*m.m42 - m.m24*m.m41*m.m32,
       -m.m21*m.m32*m.m43 + m.m21*m.m42*m.m33 + m.m22*m.m31*m.m43 - m.m22*m.m41*m.m33 - m.m23*m.m31*m.m42 + m.m23*m.m41*m.m32,
       -m.m12*m.m33*m.m44 + m.m12*m.m43*m.m34 + m.m13*m.m32*m.m44 - m.m13*m.m42*m.m34 - m.m14*m.m32*m.m43 + m.m14*m.m42*m.m33,
        m.m11*m.m33*m.m44 - m.m11*m.m43*m.m34 - m.m13*m.m31*m.m44 + m.m13*m.m41*m.m34 + m.m14*m.m31*m.m43 - m.m14*m.m41*m.m33,
       -m.m11*m.m32*m.m44 + m.m11*m.m42*m.m34 + m.m12*m.m31*m.m44 - m.m12*m.m41*m.m34 - m.m14*m.m31*m.m42 + m.m14*m.m41*m.m32,
        m.m11*m.m32*m.m43 - m.m11*m.m42*m.m33 - m.m12*m.m31*m.m43 + m.m12*m.m41*m.m33 + m.m13*m.m31*m.m42 - m.m13*m.m41*m.m32,
        m.m12*m.m23*m.m44 - m.m12*m.m43*m.m24 - m.m13*m.m22*m.m44 + m.m13*m.m42*m.m24 + m.m14*m.m22*m.m43 - m.m14*m.m42*m.m23,
       -m.m11*m.m23*m.m44 + m.m11*m.m43*m.m24 + m.m13*m.m21*m.m44 - m.m13*m.m41*m.m24 - m.m14*m.m21*m.m43 + m.m14*m.m41*m.m23,
        m.m11*m.m22*m.m44 - m.m11*m.m42*m.m24 - m.m12*m.m21*m.m44 + m.m12*m.m41*m.m24 + m.m14*m.m21*m.m42 - m.m14*m.m41*m.m22,
       -m.m11*m.m22*m.m43 + m.m11*m.m42*m.m23 + m.m12*m.m21*m.m43 - m.m12*m.m41*m.m23 - m.m13*m.m21*m.m42 + m.m13*m.m41*m.m22,
       -m.m12*m.m23*m.m34 + m.m12*m.m33*m.m24 + m.m13*m.m22*m.m34 - m.m13*m.m32*m.m24 - m.m14*m.m22*m.m33 + m.m14*m.m32*m.m23,
        m.m11*m.m23*m.m34 - m.m11*m.m33*m.m24 - m.m13*m.m21*m.m34 + m.m13*m.m31*m.m24 + m.m14*m.m21*m.m33 - m.m14*m.m31*m.m23,
       -m.m11*m.m22*m.m34 + m.m11*m.m32*m.m24 + m.m12*m.m21*m.m34 - m.m12*m.m31*m.m24 - m.m14*m.m21*m.m32 + m.m14*m.m31*m.m22,
        m.m11*m.m22*m.m33 - m.m11*m.m32*m.m23 - m.m12*m.m21*m.m33 + m.m12*m.m31*m.m23 + m.m13*m.m21*m.m32 - m.m13*m.m31*m.m22)
       local det = m.m11*inv.m11 + m.m21*inv.m12 + m.m31*inv.m13 + m.m41*inv.m14
       inv.m11 = inv.m11 / det; inv.m21 = inv.m21 / det; inv.m31 = inv.m31 / det; inv.m41 = inv.m41 / det
       inv.m12 = inv.m12 / det; inv.m22 = inv.m22 / det; inv.m32 = inv.m32 / det; inv.m42 = inv.m42 / det
       inv.m13 = inv.m13 / det; inv.m23 = inv.m23 / det; inv.m33 = inv.m33 / det; inv.m43 = inv.m43 / det
       inv.m14 = inv.m14 / det; inv.m24 = inv.m24 / det; inv.m34 = inv.m34 / det; inv.m44 = inv.m44 / det
       return inv
    elseif i == 'gl' then
      return ffi.cast(glFloatp, m)
    end
    return nil
  end,
  __tostring = function(m)
    return string.format("[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]",
                           m.m11, m.m21, m.m31, m.m41, m.m12, m.m22, m.m32, m.m42, m.m13, m.m23, m.m33, m.m43, m.m14, m.m24, m.m34, m.m44)
    end
})

local function rotate2(r)
  return mat2(cos(r), -sin(r),
              sin(r),  cos(r))
end
local function rotate3x(r)
  return mat3(1,     0,       0,
              0, cos(r), -sin(r),
              0, sin(r),  cos(r))
end
local function rotate3y(r)
  return mat3(cos(r), 0, sin(r),
                   0, 1,      0,
             -sin(r), 0, cos(r))
end
local function rotate3z(r)
  return mat3(cos(r), -sin(r), 0,
              sin(r),  cos(r), 0,
                   0,       0, 1)
end
local function rotate3(rx, ry, rz)
  return rotate3x(rx) * rotate3y(ry) * rotate3z(rz)
end
local function rotate4x(r)
  return mat4(1,     0,        0, 0,
              0, cos(r), -sin(r), 0,
              0, sin(r),  cos(r), 0,
              0,      0,       0, 1)
end
local function rotate4y(r)
  return mat4(cos(r), 0, sin(r), 0,
                   0, 1,      0, 0,
             -sin(r), 0, cos(r), 0,
                   0, 0,      0, 1)
end
local function rotate4z(r)
  return mat4(cos(r), -sin(r), 0, 0,
              sin(r),  cos(r), 0, 0,
                   0,       0, 1, 0,
                   0,       0, 0, 1)
end
local function rotate4(rx, ry, rz)
  return rotate4x(rx) * rotate4y(ry) * rotate4z(rz)
end

M.mat2 = mat2
M.mat3 = mat3
M.mat4 = mat4
M.mat  = mat4
M.rotate2  = rotate2
M.rotate3x = rotate3x
M.rotate3y = rotate3y
M.rotate3z = rotate3z
M.rotate3  = rotate3
M.rotate4x = rotate4x
M.rotate4y = rotate4y
M.rotate4z = rotate4z
M.rotate4  = rotate4
M.rotatex  = rotate4x
M.rotatey  = rotate4y
M.rotatez  = rotate4z
M.rotate   = rotate4
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

function M.translate(x, y, z)
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

function M.frustum(l, r, b, t, n, f)
  return mat4(2*n/(r-l),         0,  (r+l)/(r-l),            0,
                      0, 2*n/(t-b),  (t+b)/(t-b),            0,
                      0,         0, -(f+n)/(f-n), -2*n*f/(f-n),
                      0,         0,           -1,            0)
end
function M.perspective(fovy, aspect, n, f)
   local t = n * math.tan(fovy * math.pi / 360.0)
   local r = t * aspect
   return M.frustum(-r, r, -t, t, n, f)
end
function M.ortho(l, r, b, t, n, f)
  return mat4(2/(r-l),       0,        0, -(r+l)/(r-l),
                    0, 2/(t-b),        0, -(t+b)/(t-b),
                    0,       0, -2/(f-n), -(f+n)/(f-n),
                    0,       0,        0,            1)
end

return M
