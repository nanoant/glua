-- LuaJIT FFI GLUT demo
-- Author: Adam Strzelecki http://www.nanoant.com/
--
-- Usage: Use left mouse button to rotate cube, right mouse button to rotate lights

local g = require 'glua'
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
  [g.GL_VERTEX_SHADER]   = 'shaders/normal.vert',
  [g.GL_FRAGMENT_SHADER] = 'shaders/normal.frag'
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
g.glutInitDisplayMode(
  g.GLUT_RGBA +
  g.GLUT_DOUBLE +
  g.GLUT_DEPTH +
  g.GLUT_MULTISAMPLE)
g.glutInitWindowSize(500, 500)
g.glutInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = g.glutCreateWindow("Teapot")
local width, height
local buttons = {}

-- set up background color
g.glClearColor(.2, .2, .2, 0)
g.glEnable(g.GL_CULL_FACE)

-- enable depth test & lighting
g.glEnable(g.GL_DEPTH_TEST)
g.glEnable(g.GL_LIGHTING)
g.glShadeModel(g.GL_SMOOTH)

-- set up material
g.glMaterial(g.GL_FRONT, g.GL_AMBIENT,   .1, .1, .1, 1)
g.glMaterial(g.GL_FRONT, g.GL_DIFFUSE,   .5, .5, .5, 1)
g.glMaterial(g.GL_FRONT, g.GL_SPECULAR,  1,  1,  1,  1)
g.glMaterial(g.GL_FRONT, g.GL_SHININESS, .2)

-- set up position
g.glMatrixMode(g.GL_MODELVIEW)
g.glTranslatef(0, 0, -2)

-- set up light
for l = 1, #lights do
  g.glEnable(g.GL_LIGHT0+l-1)
  if lights[l].position then g.glLight(g.GL_LIGHT0+l-1, g.GL_POSITION, unpack(lights[l].position)) end
  if lights[l].ambient  then g.glLight(g.GL_LIGHT0+l-1, g.GL_AMBIENT,  unpack(lights[l].ambient))  end
  if lights[l].diffuse  then g.glLight(g.GL_LIGHT0+l-1, g.GL_DIFFUSE,  unpack(lights[l].diffuse))  end
  if lights[l].specular then g.glLight(g.GL_LIGHT0+l-1, g.GL_SPECULAR, unpack(lights[l].specular)) end
end

-- set up texture
local textures = g.glGenTextures(2)
local storageMap = {
  [1] = g.GL_ALPHA,
  [3] = g.GL_RGB,
  [4] = g.GL_RGBA
}
for target, path in pairs(texturePaths) do
  local texture = textures[target] -- zero indexed
  local data, width, height, channels = imglib.bitmap(path)
  if data then
    local storage = storageMap[channels]
    g.glActiveTexture(g.GL_TEXTURE0 + target)
    g.glEnable(g.GL_TEXTURE_2D)
    g.glBindTexture(g.GL_TEXTURE_2D, texture)
    g.gluBuild2DMipmaps(g.GL_TEXTURE_2D,    -- texture to specify
                        storage,            -- internal texture storage format
                        width,              -- texture width
                        height,             -- texture height
                        storage,            -- pixel format
                        g.GL_UNSIGNED_BYTE, -- color component format
                        data)               -- pointer to texture image
    data = nil
    g.glTexParameteri(g.GL_TEXTURE_2D, g.GL_TEXTURE_MIN_FILTER, g.GL_LINEAR)
    g.glTexParameteri(g.GL_TEXTURE_2D, g.GL_TEXTURE_MAG_FILTER, g.GL_LINEAR)
    g.glTexEnvf(g.GL_TEXTURE_ENV, g.GL_TEXTURE_ENV_MODE, g.GL_MODULATE)
  end
end

-- load shaders
local program = g.glCreateProgram()
for type, path in pairs(shaderPaths) do
  local f = assert(io.open(path, 'rb'))
  local source = f:read('*all')
  local shader = g.glCreateShader(type)
  f:close()
  g.glShaderSource(shader, source)
  g.glCompileShader(shader)
  if not g.glGetShader(shader, g.GL_COMPILE_STATUS) then
    error(g.glGetShaderInfoLog(shader))
  end
  g.glAttachShader(program, shader)
end
g.glLinkProgram(program)
if not g.glGetProgram(program, g.GL_LINK_STATUS) then
  error(g.glGetProgramInfoLog(program))
end
g.glUseProgram(program)
local numLightsLocation = g.glGetUniformLocation(program, 'numLights')
g.glUniform1i(numLightsLocation, #lights)
local colorLocation = g.glGetUniformLocation(program, 'colorTex')
g.glUniform1i(colorLocation, 0)
local normalLocation = g.glGetUniformLocation(program, 'normalTex')
g.glUniform1i(normalLocation, 1)

-- called upon window resize & creation
g.glutReshapeFunc(function(w, h)
  width, height = w, h
  g.glViewport(0, 0, w, h)

  g.glMatrixMode(g.GL_PROJECTION)
  g.glLoadIdentity()
  g.gluPerspective(60, w / h, 0.2, 1000000)

  g.glMatrixMode(g.GL_MODELVIEW)
end)

-- idle callbacks
local lightsRotation = 0
local lightsRotationAxis = { .3, 1, 0 }
local rotateCallback = g.glutIdleCallback(function()
  lightsRotation = lightsRotation + .1
  g.glPushMatrix()
  g.glRotate(lightsRotation, unpack(lightsRotationAxis))
  for l = 1, #lights do
    if lights[l].position then g.glLight(g.GL_LIGHT0+l-1, g.GL_POSITION, unpack(lights[l].position)) end
  end
  g.glPopMatrix()
  g.glutPostRedisplay()
end)

-- called when mouse moves
g.glutMotionFunc(function(x, y)
  local left = buttons[g.GLUT_LEFT_BUTTON]
  if left and left.state == g.GLUT_DOWN then
    g.glRotate(x - left.x, 0, 1, 0)
    g.glRotate(y - left.y, 1, 0, 0)
    left.x = x
    left.y = y
    g.glPushMatrix()
    g.glRotate(lightsRotation, unpack(lightsRotationAxis))
    for l = 1, #lights do
      if lights[l].position then g.glLight(g.GL_LIGHT0+l-1, g.GL_POSITION, unpack(lights[l].position)) end
    end
    g.glPopMatrix()
    g.glutPostRedisplay()
  end
end)

-- called when mouse button is clicked
g.glutMouseFunc(function(button, state, x, y)
  buttons[button] = {state = state, x = x, y = y}
  -- rotate teapot
  if button == g.GLUT_RIGHT_BUTTON then
    if state == g.GLUT_DOWN then
      g.glutIdleFunc(rotateCallback)
    else
      g.glutIdleFunc(nil)
    end
  end
end)

-- main drawing function
g.glutDisplayFunc(function()

  g.glClear(g.GL_COLOR_BUFFER_BIT + g.GL_DEPTH_BUFFER_BIT)

  -- draw object
  g.solidCube(1)

  -- draw lights positions
  g.glUseProgram(0)
  g.glDisable(g.GL_LIGHTING)
  g.glDisable(g.GL_TEXTURE_2D)
  g.glPointSize(20)
  g.glPushMatrix()
  g.glRotate(lightsRotation, unpack(lightsRotationAxis))
  g.glBegin(g.GL_POINTS)
  for l = 1, #lights do
    if lights[l].diffuse  then g.glColor4f(unpack(lights[l].diffuse))   end
    if lights[l].position then g.glVertex4f(unpack(lights[l].position)) end
  end
  g.glEnd()
  g.glPopMatrix()
  g.glEnable(g.GL_TEXTURE_2D)
  g.glEnable(g.GL_LIGHTING)
  g.glUseProgram(program)

  g.glutSwapBuffers()
end)

-- enter main loop
g.glutMainLoop()
