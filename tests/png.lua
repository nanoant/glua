local png = require 'lib.png'

local bitmap, width, height, channels = png.Bitmap('textures/GraniteWall-ColorMap.png')

print('width='..width)
print('height='..height)
print('channels='..channels)
