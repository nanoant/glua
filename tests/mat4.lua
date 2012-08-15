package.path = "../?.lua;../?/init.lua;" .. package.path

local gl   = require 'matrix'
local math = require 'math'
local iter = 2000000 -- 2M
print(string.format('testing mat4 %d interations:', iter)); io.stdout:flush()

-- matrix * constant
local a = gl.identity
local start = os.clock()
for i = 1, iter do
  a = a * 1.001
end
print(string.format('matrix * constant in %f seconds', os.clock()-start)); io.stdout:flush()

-- matrix * vector
local a = gl.rotate(math.pi/2,-math.pi/2,math.pi/2)
local v = gl.vec(1,2,3,1)
local start = os.clock()
for i = 1, iter do
  v = a * v
end
print(string.format('matrix * vector   in %f seconds', os.clock()-start)); io.stdout:flush()
-- print(v)

-- matrix * matrix
local a = gl.identity
local b = gl.rotate(math.pi/2,-math.pi/2,math.pi/2)
local start = os.clock()
for i = 1, iter do
  a = a * b
end
print(string.format('matrix * matrix   in %f seconds', os.clock()-start)); io.stdout:flush()

-- matrix transpose
local a = gl.rotate(math.pi/2,-math.pi/2,math.pi/2)
local start = os.clock()
for i = 1, iter do
  a = a.t
end
print(string.format('matrix transpose  in %f seconds', os.clock()-start)); io.stdout:flush()
-- print(a)

-- matrix inverse
local a = gl.rotate(math.pi/2,-math.pi/2,math.pi/2)
local start = os.clock()
for i = 1, iter do
  a = a.inv
end
print(string.format('matrix inverse    in %f seconds', os.clock()-start)); io.stdout:flush()
-- print(a)

-- matrix det
local a = gl.rotate(math.pi/2,-math.pi/2,math.pi/2)
local start = os.clock()
for i = 1, iter do
  d = a.det
end
print(string.format('matrix det        in %f seconds', os.clock()-start)); io.stdout:flush()
-- print(a)
