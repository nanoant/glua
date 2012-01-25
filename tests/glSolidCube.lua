#!/usr/bin/env luajit

-- LuaJIT FFI GLUT demo
-- Author: Adam Strzelecki http://www.nanoant.com/
--
-- Usage: Use left mouse button to rotate cube, right mouse button to rotate lights

local gl = require 'gl'
local ok, imglib = pcall(require, 'mac.CoreGraphics')
if not ok then imglib = require 'lib.png' end

-- http://www.tutorialsforblender3d.com/Textures/Bricks-NormalMap/Bricks_Normal_1.html
-- http://www.tutorialsforblender3d.com/Textures/Wall-NormalMap/Wall_Normal_1.html
local texturePaths = {
  [0] = 'textures/GraniteWall-ColorMap.png',
  [1] = 'textures/GraniteWall-NormalMap.png'
  -- [0] = 'textures/AncientStoneSlabs-ColorMap.png',
  -- [1] = 'textures/AncientStoneSlabs-NormalMap.png'
}

local shaderPaths = {
  [gl.VERTEX_SHADER]   = 'shaders/normal.vert',
  [gl.FRAGMENT_SHADER] = 'shaders/normal.frag'
}

local lights = {
  {
    position = {  0,  0,  .8, 1  },
    ambient  = {  0,  0,  0,  1  },
    diffuse  = {  1,  1,  1,  1  },
    specular = {  1,  1,  1,  1  }
  },
  {
    position = { -1,  1, -1,  1  },
    ambient  = {  0,  0,  0,  1  },
    diffuse  = {  .8, .8, 1,  1  },
    specular = {  .8, .8, 1,  1  }
  },
  {
    position = {  1,  0, -1,  1  },
    ambient  = {  0,  0,  0,  1  },
    diffuse  = {  1,  .2, .2, 1  },
    specular = {  1,  .2, .2, 1  }
  }
}

-- initialize display (note: glut module calls glutInit)
gl.utInitDisplayMode(
  gl.UT_RGBA +
  gl.UT_DOUBLE +
  gl.UT_DEPTH +
  gl.UT_MULTISAMPLE)
gl.utInitWindowSize(500, 500)
gl.utInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = gl.utCreateWindow("Teapot")
local width, height
local buttons = {}

-- set up background color
gl.ClearColor(.2, .2, .2, 0)
gl.Enable(gl.CULL_FACE)

-- enable depth test & lighting
gl.Enable(gl.DEPTH_TEST)
gl.Enable(gl.LIGHTING)
gl.ShadeModel(gl.SMOOTH)

-- set up material
gl.Material(gl.FRONT, gl.AMBIENT,   .1, .1, .1, 1)
gl.Material(gl.FRONT, gl.DIFFUSE,   .5, .5, .5, 1)
gl.Material(gl.FRONT, gl.SPECULAR,  1,  1,  1,  1)
gl.Material(gl.FRONT, gl.SHININESS, .2)

-- set up position
gl.MatrixMode(gl.MODELVIEW)
gl.Translatef(0, 0, -2)

-- set up light
for l = 1, #lights do
  gl.Enable(gl.LIGHT0+l-1)
  if lights[l].position then gl.Light(gl.LIGHT0+l-1, gl.POSITION, unpack(lights[l].position)) end
  if lights[l].ambient  then gl.Light(gl.LIGHT0+l-1, gl.AMBIENT,  unpack(lights[l].ambient))  end
  if lights[l].diffuse  then gl.Light(gl.LIGHT0+l-1, gl.DIFFUSE,  unpack(lights[l].diffuse))  end
  if lights[l].specular then gl.Light(gl.LIGHT0+l-1, gl.SPECULAR, unpack(lights[l].specular)) end
end

-- set up texture
local textures = gl.GenTextures(2)
local storageMap = {
  [1] = gl.ALPHA,
  [3] = gl.RGB,
  [4] = gl.RGBA
}
for target, path in pairs(texturePaths) do
  local texture = textures[target] -- zero indexed
  local data, width, height, channels = imglib.bitmap(path)
  if data then
    local storage = storageMap[channels]
    gl.ActiveTexture(gl.TEXTURE0 + target)
    gl.Enable(gl.TEXTURE_2D)
    gl.BindTexture(gl.TEXTURE_2D, texture)
    gl.uBuild2DMipmaps(gl.TEXTURE_2D,    -- texture to specify
                        storage,            -- internal texture storage format
                        width,              -- texture width
                        height,             -- texture height
                        storage,            -- pixel format
                        gl.UNSIGNED_BYTE, -- color component format
                        data)               -- pointer to texture image
    data = nil
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
    gl.TexEnvf(gl.TEXTURE_ENV, gl.TEXTURE_ENV_MODE, gl.MODULATE)
  end
end

-- load shaders
local program = gl.CreateProgram()
for type, path in pairs(shaderPaths) do
  local f = assert(io.open(path, 'rb'))
  local source = f:read('*all')
  local shader = gl.CreateShader(type)
  f:close()
  gl.ShaderSource(shader, source)
  gl.CompileShader(shader)
  if not gl.GetShader(shader, gl.COMPILE_STATUS) then
    error(gl.GetShaderInfoLog(shader))
  end
  gl.AttachShader(program, shader)
end
gl.LinkProgram(program)
if not gl.GetProgram(program, gl.LINK_STATUS) then
  error(gl.GetProgramInfoLog(program))
end
gl.UseProgram(program)
local numLightsLocation = gl.GetUniformLocation(program, 'numLights')
gl.Uniform1i(numLightsLocation, #lights)
local colorLocation = gl.GetUniformLocation(program, 'colorTex')
gl.Uniform1i(colorLocation, 0)
local normalLocation = gl.GetUniformLocation(program, 'normalTex')
gl.Uniform1i(normalLocation, 1)

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  width, height = w, h
  gl.Viewport(0, 0, w, h)

  gl.MatrixMode(gl.PROJECTION)
  gl.LoadIdentity()
  gl.uPerspective(60, w / h, 0.2, 1000000)

  gl.MatrixMode(gl.MODELVIEW)
end)

-- idle callbacks
local lightsRotation = 0
local lightsRotationAxis = { .3, 1, 0 }
local rotateCallback = gl.utIdleCallback(function()
  lightsRotation = lightsRotation + .1
  gl.PushMatrix()
  gl.Rotate(lightsRotation, unpack(lightsRotationAxis))
  for l = 1, #lights do
    if lights[l].position then gl.Light(gl.LIGHT0+l-1, gl.POSITION, unpack(lights[l].position)) end
  end
  gl.PopMatrix()
  gl.utPostRedisplay()
end)

-- called when mouse moves
gl.utMotionFunc(function(x, y)
  local left = buttons[gl.UT_LEFT_BUTTON]
  if left and left.state == gl.UT_DOWN then
    gl.Rotate(x - left.x, 0, 1, 0)
    gl.Rotate(y - left.y, 1, 0, 0)
    left.x = x
    left.y = y
    gl.PushMatrix()
    gl.Rotate(lightsRotation, unpack(lightsRotationAxis))
    for l = 1, #lights do
      if lights[l].position then gl.Light(gl.LIGHT0+l-1, gl.POSITION, unpack(lights[l].position)) end
    end
    gl.PopMatrix()
    gl.utPostRedisplay()
  end
end)

-- called when mouse button is clicked
gl.utMouseFunc(function(button, state, x, y)
  buttons[button] = {state = state, x = x, y = y}
  -- rotate teapot
  if button == gl.UT_RIGHT_BUTTON then
    if state == gl.UT_DOWN then
      gl.utIdleFunc(rotateCallback)
    else
      gl.utIdleFunc(nil)
    end
  end
end)

-- main drawing function
gl.utDisplayFunc(function()

  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)

  -- draw object
  gl.SolidCube(1)

  -- draw lights positions
  gl.UseProgram(0)
  gl.Disable(gl.LIGHTING)
  gl.Disable(gl.TEXTURE_2D)
  gl.PointSize(20)
  gl.PushMatrix()
  gl.Rotate(lightsRotation, unpack(lightsRotationAxis))
  gl.Begin(gl.POINTS)
  for l = 1, #lights do
    if lights[l].diffuse  then gl.Color4f(unpack(lights[l].diffuse))   end
    if lights[l].position then gl.Vertex4f(unpack(lights[l].position)) end
  end
  gl.End()
  gl.PopMatrix()
  gl.Enable(gl.TEXTURE_2D)
  gl.Enable(gl.LIGHTING)
  gl.UseProgram(program)

  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
