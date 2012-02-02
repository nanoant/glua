#!/usr/bin/env luajit

-- LuaJIT FFI GLUT demo
-- Author: Adam Strzelecki http://www.nanoant.com/
--
-- Usage: Use left mouse button to rotate cube, right mouse button to rotate lights

local gl = require 'gl'

-- http://www.tutorialsforblender3d.com/Textures/Bricks-NormalMap/Bricks_Normal_1.html
-- http://www.tutorialsforblender3d.com/Textures/Wall-NormalMap/Wall_Normal_1.html
local textures = {
  [0] = 'textures/GraniteWall-ColorMap.png',
  [1] = 'textures/GraniteWall-NormalMap.png'
}
local normalShader = {
  [gl.VERTEX_SHADER]   = 'shaders/normal.vert',
  [gl.FRAGMENT_SHADER] = 'shaders/normal.frag'
}
local colorShader = {
  [gl.VERTEX_SHADER]   = 'shaders/color.vert',
  [gl.FRAGMENT_SHADER] = 'shaders/color.frag'
}
local lights = {
  {
    position = {  1.3, 1.3, 1.3  },
    ambient  = {  0,  0,  0  },
    diffuse  = {  1,  0,  0  },
    specular = {  1,  1,  1  }
  },
  {
    position = {  0,  0, -1.3  },
    ambient  = {  0,  0,  0  },
    diffuse  = {  1,  1,  0  },
    specular = {  1,  1,  1  }
  },
  {
    position = { -1.3, 0,  1.3  },
    ambient  = {  0,  0,  0  },
    diffuse  = {  0,  0,  1  },
    specular = {  0,  0,  1  }
  }
}

-- initialize display (note: glut module calls glutInit)
gl.utInitDisplayString('rgba double depth>=16 samples~8')
gl.utInitWindowSize(500, 500)
gl.utInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = gl.utCreateWindow("Solid Cube")
local width, height
local buttons = {}

-- set up background color
gl.ClearColor(.2, .2, .2, 0)
gl.Enable(gl.CULL_FACE)

-- enable depth test
gl.Enable(gl.DEPTH_TEST)

-- set up textures
local textures = gl.Textures(textures)

-- load shaders
local normalProgram = gl.Program(normalShader)
-- local colorProgram = gl.Program(colorShader)
gl.UseProgram(normalProgram.gl)

-- set up lights
gl.Uniform1i(normalProgram.numLights, #lights)
local lightPosition = gl.vvec3(#lights)
local lightAmbient  = gl.vvec3(#lights)
local lightDiffuse  = gl.vvec3(#lights)
local lightSpecular = gl.vvec3(#lights)
for l = 1, #lights do
  if lights[l].position then lightPosition[l-1] = gl.vec3(unpack(lights[l].position)) end
  if lights[l].ambient  then lightAmbient[l-1]  = gl.vec3(unpack(lights[l].ambient))  end
  if lights[l].diffuse  then lightDiffuse[l-1]  = gl.vec3(unpack(lights[l].diffuse))  end
  if lights[l].specular then lightSpecular[l-1] = gl.vec3(unpack(lights[l].specular)) end
end
gl.Uniform3fv(normalProgram.lightPosition, #lights, lightPosition[0].gl)
gl.Uniform3fv(normalProgram.lightAmbient,  #lights, lightAmbient[0].gl)
gl.Uniform3fv(normalProgram.lightDiffuse,  #lights, lightDiffuse[0].gl)
gl.Uniform3fv(normalProgram.lightSpecular, #lights, lightSpecular[0].gl)

-- set up texture mapping
gl.Uniform1i(normalProgram.colorTex,  0)
gl.Uniform1i(normalProgram.normalTex, 1)

-- set up material
normalProgram.materialAmbient   = {.1, .1, .1}
normalProgram.materialDiffuse   = {.5, .5, .5}
normalProgram.materialSpecular  = {1,  1,  1 }
normalProgram.materialShininess = .2

-- load solid cube
local cubeArray  = gl.CubeArray(normalProgram)

-- setup matrices
local projection = gl.identity
local view       = gl.Translate(0,0,-4)
local model      = gl.identity
local light      = gl.identity

normalProgram.lightMatrix = light

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  width, height = w, h
  projection = gl.Perspective(60, w / h, .1, 1000)
  gl.Viewport(0, 0, w, h)
end)

-- idle callbacks
local rotateCallback = gl.utIdleCallback(function()
  light = gl.Rotatey(.002) * light
  normalProgram.lightMatrix = light
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
  normalProgram.projectionMatrix          = projection
  normalProgram.modelViewMatrix           = modelView
  normalProgram.modelViewProjectionMatrix = projection * modelView
  normalProgram.normalMatrix              = modelView.inv.t.mat3

  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.BindVertexArray(cubeArray)
  gl.DrawArrays(gl.TRIANGLES, 0, 36)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
