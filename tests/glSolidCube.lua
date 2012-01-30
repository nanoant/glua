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

-- set up position
-- gl.MatrixMode(gl.MODELVIEW)
-- gl.Translatef(0, 0, -2)

-- set up light
local lightPosition = gl.vvec3(#lights)
local lightAmbient  = gl.vvec3(#lights)
local lightDiffuse  = gl.vvec3(#lights)
local lightSpecular = gl.vvec3(#lights)
lightPosition[0] = gl.vec3(1,2,3)
for l = 0, #lights-1 do
  -- if lights[l].position then lightPosition[l] = gl.vec3(unpack(lights[l].position)) end
  -- if lights[l].ambient  then lightAmbient[l]  = gl.vec3(unpack(lights[l].ambient))  end
  -- if lights[l].diffuse  then lightDiffuse[l]  = gl.vec3(unpack(lights[l].diffuse))  end
  -- if lights[l].specular then lightSpecular[l] = gl.vec3(unpack(lights[l].specular)) end
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
    error(path.."\n"..gl.GetShaderInfoLog(shader))
  end
  gl.AttachShader(program, shader)
end
gl.LinkProgram(program)
if not gl.GetProgram(program, gl.LINK_STATUS) then
  error(gl.GetProgramInfoLog(program))
end
gl.UseProgram(program)
gl.Uniform1i(gl.GetUniformLocation(program, 'numLights'), #lights)
gl.Uniform1i(gl.GetUniformLocation(program, 'colorTex'),  0)
gl.Uniform1i(gl.GetUniformLocation(program, 'normalTex'), 1)

-- set up material
gl.Uniform3f(gl.GetUniformLocation(program, 'matAmbient'),   .1, .1, .1)
gl.Uniform3f(gl.GetUniformLocation(program, 'matDiffuse'),   .5, .5, .5)
gl.Uniform3f(gl.GetUniformLocation(program, 'matSpecular'),  1,  1,  1)
gl.Uniform1f(gl.GetUniformLocation(program, 'matShininess'), .2)

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  width, height = w, h
  gl.Viewport(0, 0, w, h)

  local projection = gl.Perspective(60, w / h, 0.2, 1000000)
  local modelView  = gl.Translate(0, 0, -2)
  gl.UniformMatrix4fv(gl.GetUniformLocation(program, 'projectionMatrix'), 1, 0, projection.data)
  gl.UniformMatrix4fv(gl.GetUniformLocation(program, 'modelViewMatrix'), 1, 0, modelView.data)
  gl.UniformMatrix4fv(gl.GetUniformLocation(program, 'normalMatrix'), 1, 0, modelView.mat3.inv.t.data)
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

local solidCube = gl.SolidCube()

-- FIXME: for time being
gl.QUADS = 0x0007

-- main drawing function
gl.utDisplayFunc(function()
  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.DrawArrays(gl.QUADS, 0, 192)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
