#!/usr/bin/env luajit

package.path = "../?.lua;../?/init.lua;" .. package.path

local gl = require('glua')

local core = true
for i = 1, #arg do
  if     arg[i]:match('^--compat$') then core = false
  elseif arg[i]:match('^--help$')   then
    print [[
    --help   Shows help
    --compat Use compatibility profile]]
  end
end
if core then
  gl.utInitContextVersion(3, 2)
  gl.utInitContextFlags(gl.UT_FORWARD_COMPATIBLE + gl.UT_DEBUG)
  gl.utInitContextProfile(gl.UT_CORE_PROFILE)
end
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

local version = tonumber(gl.GetString(gl.SHADING_LANGUAGE_VERSION))
if version == nil or version < 1.50 then
  print()
  print('GL_EXTENSIONS = '..gl.GetString(gl.EXTENSIONS))
end