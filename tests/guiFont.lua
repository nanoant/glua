local gl  = require 'gl'
local gui = require 'gui'
local size  = 20
local font  = '/System/Library/Fonts/LucidaGrande.ttc'
local lorem = [[
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
]]

local guiShader = {
  [gl.VERTEX_SHADER]   = 'shaders/gui.vert',
  [gl.FRAGMENT_SHADER] = 'shaders/gui.frag'
}

-- initialize display (note: glut module calls glutInit)
gl.utInitDisplayString('rgba double depth>=16 samples~8')
gl.utInitWindowSize(640, 480)
gl.utInitWindowPosition(100, 100)

-- create window & local mouse state variables
local window = gl.utCreateWindow("Font")
local font = gui.Font{ size = size, font = font }

gl.ClearColor(0,.2,.4,1)
gl.Enable(gl.BLEND)
gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

-- load shaders
local guiProgram = gl.Program(guiShader)
gl.UseProgram(guiProgram.gl)
gl.Uniform4f(guiProgram.color, 1, 1, 0, 1)
gl.Uniform1i(guiProgram.alphaOnly, 1)

local textArray, textSize

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  guiProgram.modelViewProjectionMatrix = gl.Ortho(0, w, h, 0, -1, 0)
  if textArray then gl.DeleteVertexArray(textArray) end
  textArray, textSize = font:array(guiProgram, lorem..gl.GetString(gl.EXTENSIONS), w)
  gl.Viewport(0, 0, w, h)
end)

-- main drawing function
gl.utDisplayFunc(function()
  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.BindVertexArray(textArray)
  gl.DrawArrays(gl.TRIANGLES, 0, textSize)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
