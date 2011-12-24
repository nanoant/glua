-- LuaJIT FFI GLUT demo
-- Author: Adam Strzelecki http://www.nanoant.com/

local g  = require('glua')
local cg = require('mac.CoreGraphics')

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
g.glClearColor(0, 0, 1, 0)

-- enable depth test & lighting
g.glEnable(g.GL_DEPTH_TEST)
g.glEnable(g.GL_LIGHTING)
g.glEnable(g.GL_LIGHT0)
g.glShadeModel(g.GL_SMOOTH)

-- set up light
g.glMaterial(g.GL_FRONT, g.GL_AMBIENT,   .1, .1, .1, 1)
g.glMaterial(g.GL_FRONT, g.GL_DIFFUSE,   .5, .5, .5, 1)
g.glMaterial(g.GL_FRONT, g.GL_SPECULAR,  1,  1,  1,  1)
g.glMaterial(g.GL_FRONT, g.GL_SHININESS, 30)
g.glLight(g.GL_LIGHT0,   g.GL_POSITION,  0, 0, 0, 0)

-- set up texture
local texture
local textureData, width, height, bpc = cg.bitmap('textures/marble.png')
if textureData then
  texture = g.glGenTexture()
  g.glBindTexture(g.GL_TEXTURE_2D, texture)
  g.gluBuild2DMipmaps(g.GL_TEXTURE_2D,    -- texture to specify
                      g.GL_RGBA,          -- internal texture storage format
                      width,              -- texture width
                      height,             -- texture height
                      g.GL_RGBA,          -- pixel format
                      g.GL_UNSIGNED_BYTE, -- color component format
                      textureData)        -- pointer to texture image
  textureData = nil
  g.glEnable(g.GL_TEXTURE_2D)
end

-- called upon window resize & creation
g.glutReshapeFunc(function(w, h)
  width, height = w, h
  g.glViewport(0, 0, w, h)

  g.glMatrixMode(g.GL_PROJECTION)
  g.glLoadIdentity()
  g.gluPerspective(60, w / h, 0.2, 1000000)
  g.gluLookAt(0,  0, -1.5,
              0,  0,  0,
              0,  1,  0)

  g.glMatrixMode(g.GL_MODELVIEW)
end)

-- idle callbacks
local rotateCallback = g.glutIdleCallback(function()
  local m = g.glGet(g.GL_MODELVIEW_MATRIX)
  g.glLoadIdentity()
  g.glRotate(1, 0, 0, 1)
  g.glMultMatrix(m)
  g.glutPostRedisplay()
end)

-- called when mouse moves
g.glutMotionFunc(function(x, y)
  local left = buttons[g.GLUT_LEFT_BUTTON]
  if left and left.state == g.GLUT_DOWN then
    local m = g.glGet(g.GL_MODELVIEW_MATRIX)
    g.glLoadIdentity()
    g.glRotate(left.x - x, 0, -1, 0)
    g.glRotate(left.y - y, 1, 0, 0)
    left.x = x
    left.y = y
    g.glMultMatrix(m)
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
 g.glutSolidTeapot(0.5)
 g.glutSwapBuffers()
end)

-- enter main loop
g.glutMainLoop()
