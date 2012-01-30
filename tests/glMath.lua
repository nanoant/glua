local gl   = require 'gl'
local math = require 'math'

local ortho = gl.Ortho(0, 640, 480, 0, -100, 100)
local proj  = gl.Perspective(0, 640, 480, 0, -100, 100)

local m2 = gl.mat2(2,1,
                   0,2)
local m3 = gl.mat3(2,1,0,
                   0,2,0,
                   0,0,2)

print(m2.inv.inv); print()
print(m3.inv.inv); print()

local m = gl.mat(2,1,0,0,
                 0,2,0,0,
                 0,0,2,0,
                 0,0,0,1)
print(m.inv.inv); print()

local trans = gl.Translate(1,2,3)

print(trans*gl.vec(1,1,1,1)); print()

print(gl.Perspective(60, 640 / 480, 0.2, 1000000).mat3.inv.t)
