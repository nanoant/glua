package.path = "../?.lua;../?/init.lua;" .. package.path

local png = require 'glua.lib.png'

local bitmap, width, height, channels = png.Bitmap('textures/GraniteWall-ColorMap.png')

print('width='..width)
print('height='..height)
print('channels='..channels)
