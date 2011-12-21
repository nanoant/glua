-- LuaJIT FFI GLUT demo
-- Author: Adam Strzelecki http://www.nanoant.com/

local g = require('glut')
local ffi = require('ffi') -- FIXME: so far we require ffi here for creating non-simple types

-- initialize display (note: glut module calls glutInit)
g.glutInitDisplayMode(g.GLUT_RGBA + g.GLUT_DOUBLE + g.GLUT_DEPTH + g.GLUT_MULTISAMPLE)
g.glutInitWindowSize(500, 500)
g.glutInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = g.glutCreateWindow("Teapot")
local width, height;
local buttons = {};

-- set up background color
g.glClearColor(0, 0, 255, 0)

-- enable depth test & lighting
g.glEnable(g.GL_DEPTH_TEST)
g.glEnable(g.GL_LIGHTING)
g.glEnable(g.GL_LIGHT0)

-- set up the light
g.glMaterialfv(g.GL_FRONT, g.GL_SPECULAR,  ffi.new('GLfloat[4]', 1, 1, 1, 1));
g.glMaterialfv(g.GL_FRONT, g.GL_SHININESS, ffi.new('GLfloat[1]', 5));
g.glLightfv(g.GL_LIGHT0, g.GL_POSITION,    ffi.new('GLfloat[4]', 10, 10, -10, 0));

-- called upon window resize & creation
g.glutReshapeFunc(function(w, h)
  width, height = w, h
  g.glViewport(0, 0, w, h);

  g.glMatrixMode(g.GL_PROJECTION)
  g.glLoadIdentity();
  g.gluPerspective(60, w / h, 0.2, 1000000)
  g.gluLookAt(0,  0, -1.5,
              0,  0,  0,
              0,  1,  0);

  g.glMatrixMode(g.GL_MODELVIEW)
end)

-- called when mouse moves
g.glutMotionFunc(function(x, y)
  left = buttons[0]
  if left and left.state then
    g.glRotatef(left.x - x, 0, -1, 0)
    g.glRotatef(left.y - y, 1, 0, 0)
    left.x = x
    left.y = y
    g.glutPostRedisplay()
  end
end)

-- called when mouse button is clicked
g.glutMouseFunc(function(button, state, x, y)
  buttons[button] = {state = state, x = x, y = y}
end)

-- main drawing function
g.glutDisplayFunc(function()
 g.glClear(g.GL_COLOR_BUFFER_BIT + g.GL_DEPTH_BUFFER_BIT)
 g.glutSolidTeapot(0.5)
 g.glutSwapBuffers()
end)

-- enter main loop
g.glutMainLoop()
