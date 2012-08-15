#!/usr/bin/env luajit

package.path = "../?.lua;../?/init.lua;" .. package.path

local gl        = require 'glua'
local primitive = require 'glua.primitive'

gl.utInitDisplayString('rgba double depth>=16 samples~8')
gl.utInitWindowSize(400, 300)
gl.utInitWindowPosition(100, 100)
local window = gl.utCreateWindow("Simple")

gl.ClearColor(.2, .2, .2, 0)

gl.utDisplayFunc(function ()
  gl.Clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
  gl.utSwapBuffers()
end)

gl.utReshapeFunc(function (w, h)
  gl.Viewport(0, 0, w, h)
end)

-- enter main loop
gl.utMainLoop()
