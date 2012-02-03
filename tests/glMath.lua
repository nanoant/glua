local gl   = require 'matrix'
local math = require 'math'

local w, h = 800, 600
local projection = gl.perspective(60, w / h, .1, 1000)

local model  = gl.identity
local view   = gl.translate(0, 0, -24)
local test   = gl.vec4(0, 0, 0, 0)

local start  = os.clock()
local modelView = view * model
for i = 1, 400 do
  test = modelView * projection
  -- test = test + projection * model * view * test
end
print(string.format('took %f seconds', os.clock()-start))
print(test)
