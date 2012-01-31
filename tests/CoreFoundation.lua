local cf = require 'mac.CoreFoundation'
local cg = require 'mac.CoreGraphics'

print('exe: '..cf.tostring(cf.ExecutableURL()))
print('res: '..cf.tostring(cf.ResourcesURL()))
print('lua: '..cf.tostring(cf.ResourceURL('mysql', 'server')))

local texPath = cf.AppendURLComponent(cf.PathURL('textures'), 'GraniteWall-ColorMap.png')

print('tex: '..cf.tostring(texPath))

local data, width, height, bpc, pitch = cg.Bitmap(texPath)

print(data)
print(' Width: '..width)
print('Height: '..height)
print('   BPC: '..bpc)
print(' Pitch: '..pitch)
