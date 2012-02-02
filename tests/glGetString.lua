#!/usr/bin/env luajit

local gl = require('gl')

gl.utInitDisplayString('rgba double depth>=16 samples~8')

gl.utInitWindowSize(500, 500)
gl.utInitWindowPosition(100, 100)
gl.utCreateWindow("Test")

print('                  GL_VENDOR: '..gl.GetString(gl.VENDOR))
print('                GL_RENDERER: '..gl.GetString(gl.RENDERER))
print('                 GL_VERSION: '..gl.GetString(gl.VERSION))
print('GL_SHADING_LANGUAGE_VERSION: '..gl.GetString(gl.SHADING_LANGUAGE_VERSION))

print()
print('         GL_ARRAY_BUFFER_BINDING = '..gl.Get(gl.ARRAY_BUFFER_BINDING))
print('                  GL_BLEND_COLOR = '..gl.Get(gl.BLEND_COLOR)[3])
print('               GL_SAMPLE_BUFFERS = '..gl.Get(gl.SAMPLE_BUFFERS))
print('          GL_MAX_3D_TEXTURE_SIZE = '..gl.Get(gl.MAX_3D_TEXTURE_SIZE))
print('      GL_MAX_TEXTURE_IMAGE_UNITS = '..gl.Get(gl.MAX_TEXTURE_IMAGE_UNITS))
print('             GL_MAX_TEXTURE_SIZE = '..gl.Get(gl.MAX_TEXTURE_SIZE))
print('GL_MAX_VERTEX_UNIFORM_COMPONENTS = '..gl.Get(gl.MAX_VERTEX_UNIFORM_COMPONENTS))

if tonumber(gl.GetString(gl.SHADING_LANGUAGE_VERSION)) < 1.50 then
  print()
  print('GL_EXTENSIONS = '..gl.GetString(gl.EXTENSIONS))
end