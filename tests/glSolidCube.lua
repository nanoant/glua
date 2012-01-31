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
  -- [gl.GEOMETRY_SHADER] = 'shaders/passthrough.geom'
}

local lights = {
  {
    position = {  1,  0,  1  },
    ambient  = {  0,  0,  0  },
    diffuse  = {  1,  0,  0  },
    specular = {  1,  1,  1  }
  },
  {
    position = { -1,  0,  1  },
    ambient  = {  0,  0,  0  },
    diffuse  = {  0,  0,  1  },
    -- specular = {  .5, .5, 1  }
    specular = {  0, 0, 1  }
  }
  -- {
  --   position = {  1,  0, -1  },
  --   ambient  = {  0,  0,  0  },
  --   diffuse  = {  1,  .2, .2 },
  --   specular = {  1,  .2, .2 }
  -- }
}

-- initialize display (note: glut module calls glutInit)
gl.utInitDisplayString('rgba double samples~8')
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
gl.BindAttribLocation(program,   0, 'position')
gl.BindAttribLocation(program,   1, 'normal')
gl.BindAttribLocation(program,   2, 'texCoord')
-- gl.BindFragDataLocation(program, 0, 'fragColor')
gl.LinkProgram(program)
if not gl.GetProgram(program, gl.LINK_STATUS) then
  error(gl.GetProgramInfoLog(program))
end
gl.UseProgram(program)

-- uniforms
local numLights         = gl.GetUniformLocation(program, 'numLights')
local colorTex          = gl.GetUniformLocation(program, 'colorTex')
local normalTex         = gl.GetUniformLocation(program, 'normalTex')
local materialAmbient   = gl.GetUniformLocation(program, 'materialAmbient')
local materialDiffuse   = gl.GetUniformLocation(program, 'materialDiffuse')
local materialSpecular  = gl.GetUniformLocation(program, 'materialSpecular')
local materialShininess = gl.GetUniformLocation(program, 'materialShininess')
local projectionMatrix  = gl.GetUniformLocation(program, 'projectionMatrix')
local lightMatrix       = gl.GetUniformLocation(program, 'lightMatrix')
local modelViewMatrix   = gl.GetUniformLocation(program, 'modelViewMatrix')
local mvpMatrix         = gl.GetUniformLocation(program, 'modelViewProjectionMatrix')
local normalMatrix      = gl.GetUniformLocation(program, 'normalMatrix')
local lightPosition     = gl.GetUniformLocation(program, 'lightPosition')
local lightAmbient      = gl.GetUniformLocation(program, 'lightAmbient')
local lightDiffuse      = gl.GetUniformLocation(program, 'lightDiffuse')
local lightSpecular     = gl.GetUniformLocation(program, 'lightSpecular')

-- set up lights
gl.Uniform1i(numLights, #lights)
local lightPositionData = gl.vvec3(#lights)
local lightAmbientData  = gl.vvec3(#lights)
local lightDiffuseData  = gl.vvec3(#lights)
local lightSpecularData = gl.vvec3(#lights)
for l = 1, #lights do
  if lights[l].position then lightPositionData[l-1] = gl.vec3(unpack(lights[l].position)) end
  if lights[l].ambient  then lightAmbientData[l-1]  = gl.vec3(unpack(lights[l].ambient))  end
  if lights[l].diffuse  then lightDiffuseData[l-1]  = gl.vec3(unpack(lights[l].diffuse))  end
  if lights[l].specular then lightSpecularData[l-1] = gl.vec3(unpack(lights[l].specular)) end
end
gl.Uniform3fv(lightPosition, #lights, lightPositionData[0].gl)
gl.Uniform3fv(lightAmbient,  #lights, lightAmbientData[0].gl)
gl.Uniform3fv(lightDiffuse,  #lights, lightDiffuseData[0].gl)
gl.Uniform3fv(lightSpecular, #lights, lightSpecularData[0].gl)

-- set up texture mapping
gl.Uniform1i(colorTex,  0)
gl.Uniform1i(normalTex, 1)

-- set up material
gl.Uniform3f(materialAmbient,   .1, .1, .1)
gl.Uniform3f(materialDiffuse,   .5, .5, .5)
gl.Uniform3f(materialSpecular,  1,  1,  1)
gl.Uniform1f(materialShininess, .2)

-- load solid cube buffer
local cubeArray  = gl.CubeArray(program)
-- local planeArray = gl.PlaneArray(program)

local projection = gl.identity
local view       = gl.Translate(0,0,-4)
local model      = gl.identity
local light      = gl.identity

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  width, height = w, h
  projection = gl.Perspective(60, w / h, .1, 1000)
  gl.Viewport(0, 0, w, h)
end)

-- idle callbacks
local rotateCallback = gl.utIdleCallback(function()
  light = gl.Rotatey(.002) * light
  gl.UniformMatrix4fv(lightMatrix, 1, gl.TRUE, light.gl)
  gl.utPostRedisplay()
end)

-- called when mouse moves
gl.utMotionFunc(function(x, y)
  local left = buttons[gl.UT_LEFT_BUTTON]
  if left and left.state == gl.UT_DOWN then
    model = gl.Rotate((y - left.y) * .007, (x - left.x) * .007, 0) * model
    left.x, left.y = x, y
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
  local modelView = view * model
  gl.UniformMatrix4fv(projectionMatrix,  1, gl.TRUE,  projection.gl)
  gl.UniformMatrix4fv(modelViewMatrix,   1, gl.TRUE,  modelView.gl)
  gl.UniformMatrix4fv(mvpMatrix,         1, gl.TRUE,  (projection*modelView).gl)
  gl.UniformMatrix3fv(normalMatrix,      1, gl.FALSE, modelView.mat3.inv.gl)

  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.BindVertexArray(cubeArray)
  gl.DrawArrays(gl.TRIANGLES, 0, 36)
  -- gl.BindVertexArray(planeArray)
  -- gl.DrawArrays(gl.TRIANGLES, 0, 6)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
