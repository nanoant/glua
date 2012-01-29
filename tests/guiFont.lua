local gl  = require 'gl'
local gui = require 'gui'
local size  = 20
local font  = '/System/Library/Fonts/LucidaGrande.ttc'
local lorem = [[
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
]]

-- initialize display (note: glut module calls glutInit)
gl.utInitDisplayMode(
  gl.UT_RGBA +
  gl.UT_DOUBLE +
  gl.UT_DEPTH)
gl.utInitWindowSize(500, 500)
gl.utInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = gl.utCreateWindow("gl.Font")
local width, height
local font = gui.Font{ size = size, font = font }

gl.ClearColor(0,.2,.4,1)
gl.Enable(gl.BLEND)
gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  width, height = w, h
  gl.Viewport(0, 0, w, h)

  gl.MatrixMode(gl.PROJECTION)
  gl.LoadIdentity()
  gl.Ortho(0, w, h, 0, -1, 0)

  gl.MatrixMode(gl.MODELVIEW)
  gl.LoadIdentity()
end)

-- main drawing function
gl.utDisplayFunc(function()
  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.Color4f(1,1,1,1)
  font:draw(lorem..gl.GetString(gl.EXTENSIONS), width)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
