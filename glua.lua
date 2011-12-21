-- LuaJIT FFI extensions for OpenGL & GLUT
-- Created by: Adam Strzelecki http://www.nanoant.com/

local g = require('glut')
local ffi = require('ffi')
local M = {}

-- float vector type
local glFloatv = ffi.typeof('GLfloat[?]')
M.glFloatv = function(...)
  return glFloatv(select('#', ...), ...)
end

-- callbacks
ffi.cdef [[
  typedef void (*glutTimerCallback)(int value);
  typedef void (*glutIdleCallback)(void);
]]
M.glutEmptyCallback = ffi.new('void *')
M.glutTimerCallback = function(f)
  return ffi.cast('glutTimerCallback', f)
end
M.glutIdleCallback = function(f)
  return ffi.cast('glutIdleCallback', f)
end

-- automatic vector generating get
local glGetMap = {
  [g.GL_MODELVIEW_MATRIX]  = 16,
  [g.GL_PROJECTION_MATRIX] = 16
}
M.glGet = function(what)
  local size = glGetMap[what]
  if size == nil then
    error('Invalid OpenGL object')
  end
  local m = glFloatv(size)
  g.glGetFloatv(what, m)
  if size == 1 then
    return m[0]
  end
  return m
end

-- light vaarg functions
M.glMaterial = function(face, type, ...)
  return g.glMaterialfv(face, type, glFloatv(select('#', ...), ...))
end
M.glLight = function(face, type, ...)
  return g.glLightfv(face, type, glFloatv(select('#', ...), ...))
end

setmetatable(M, { __index = g })

return M
