local cf = require 'CoreFoundation'
local cg = require 'CoreGraphics'

print('exe: '..cf.tostring(cf.executableURL()))
print('res: '..cf.tostring(cf.resourcesURL()))
print('lua: '..cf.tostring(cf.resourceURL('mysql', 'server')))

local texPath = cf.appendURLComponent(cf.pathURL('textures'), 'marble.png')

print('tex: '..cf.tostring(texPath))

local data, width, height, bpc, pitch = cg.bitmap(texPath)

print(data)
print(' Width: '..width)
print('Height: '..height)
print('   BPC: '..bpc)
print(' Pitch: '..pitch)
