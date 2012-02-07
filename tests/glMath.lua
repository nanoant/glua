local gl   = require 'matrix'
local math = require 'math'
local iter = 2000000 -- 20M

-- matrix * constant
local a = gl.identity
local b = gl.translate(0,0,-.1)
local start = os.clock()
for i = 1, iter do
  a = a * 1.001
end
print(string.format('matrix * constant in %f seconds', os.clock()-start)); io.stdout:flush()

-- matrix * vector
local a = gl.translate(0,0,-.1)
local v = gl.vec(1,2,3,1)
local start = os.clock()
for i = 1, iter do
  v = a * v
end
-- print(v)
print(string.format('matrix * vector   in %f seconds', os.clock()-start)); io.stdout:flush()

-- matrix * matrix
local a = gl.identity
local b = gl.translate(0,0,-.001)
local start = os.clock()
for i = 1, iter do
  a = a * b
end
print(string.format('matrix * matrix   in %f seconds', os.clock()-start)); io.stdout:flush()
