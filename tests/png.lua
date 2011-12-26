local png = require 'lib.png'

local bitmap, width, height, channels = png.bitmap('textures/marble.png')

print('width='..width)
print('height='..height)
print('channels='..channels)
