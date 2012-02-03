local gl   = require 'gl'
local math = require 'math'

local ortho = gl.ortho(0, 640, 480, 0, -100, 100)
local proj  = gl.perspective(0, 640, 480, 0, -100, 100)

local m2 = gl.mat2(2,1,
                   0,2)
local m3 = gl.mat3(2,1,0,
                   0,2,0,
                   0,0,2)

local rot = gl.rotate(.2,.3,.4)

print(rot.t); print()
print(rot.inv); print()

print(gl.identity * gl.vec3(1,2,3)); print()

print(m2.inv.inv); print()
print(m3.inv.inv); print()

local m = gl.mat(2,1,0,0,
                 0,2,0,0,
                 0,0,2,0,
                 0,0,0,1)
print(m.inv.inv); print()

local trans = gl.translate(0,0,-2)

print(trans*gl.vec(1,1,1,1)); print()

-- print(gl.Perspective(60, 640 / 480, 0.2, 1000000).mat3.inv.t)
print(trans.inv.t.mat3)
