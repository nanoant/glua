local gl  = require 'gl'
local gui = require 'gui'
local size  = 14
local lorem = [[   Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
ABCDEFGHIJKLMNOPQRSTWXYZ abcdefghijklmnopqrstwxyz 01234567890 ~!@#$%^&*()
]]
lorem = lorem..lorem..lorem..lorem..lorem..lorem


local guiShader = {
  [gl.VERTEX_SHADER]   = 'shaders/gui.vert',
  [gl.FRAGMENT_SHADER] = 'shaders/gui.frag'
}

-- initialize display (note: glut module calls glutInit)
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

-- create window & local mouse state variables
local window = gl.utCreateWindow("Font")
local font = gui.font{ size = size, font = font }
local buttons = {}

gl.ClearColor(1, 1, 1, 1)
gl.Enable(gl.BLEND)
gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
-- load shaders
local guiProgram = gl.program(guiShader)
gl.UseProgram(guiProgram.gl)
gl.Uniform4f(guiProgram.color,    0, 0, 0, 1)

local text
local glyphs = gl.array(guiProgram, {
  256, 256, 0,   0,   0,
  768, 256, 0, 512,   0,
  768, 768, 0, 512, 512,
  768, 768, 0, 512, 512, -- dup
  256, 768, 0,   0, 512,
  256, 256, 0,   0,   0, -- dup
}, 'position', 3, 'texCoord', 2)

-- called upon window resize & creation
gl.utReshapeFunc(function(w, h)
  guiProgram.modelViewProjectionMatrix = gl.ortho(0, w, h, 0, -1, 0)
  if textArray then
    gl.DeleteVertexArray(textArray)
  end
  gl.UseProgram(guiProgram.gl)
  text = font:array(guiProgram, lorem, w)
  gl.Viewport(0, 0, w, h)
end)

-- idle callbacks
local frames, clock
local idleCallback = gl.utIdleCallback(function()
  frames = frames + 1
  gl.utPostRedisplay()
end)

-- called when mouse button is clicked
gl.utMouseFunc(function(button, state, x, y)
  buttons[button] = {state = state, x = x, y = y}
  -- FPS measure
  if button == gl.UT_RIGHT_BUTTON then
    if state == gl.UT_DOWN then
      frames = 0
      clock  = os.clock()
      gl.utIdleFunc(idleCallback)
    else
      print((frames / (os.clock() - clock))..' FPS')
      gl.utIdleFunc(nil)
    end
  end
end)

-- main drawing function
gl.utDisplayFunc(function()
  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  guiProgram.color = {0, 0, 1, 1}
  guiProgram.alphaMask = true
  gl.BindVertexArray(text.gl)
  gl.DrawArrays(gl.TRIANGLES, 0, text.size)
  gl.BindVertexArray(glyphs.gl)
  guiProgram.color = {1, 0, 0, .5}
  gl.DrawArrays(gl.TRIANGLES, 0, glyphs.size)
  gl.utSwapBuffers()
end)

-- enter main loop
gl.utMainLoop()
