OpenGL for LuaJIT
=================

This is FFI driven, pure Lua(JIT) *OpenGL* module. Just put it into your *LuaJIT* modules folder, i.e.: `/usr/local/share/lua/5.1`.

This framework only defines *OpenGL 3.x Core Profile* shader pipeline functions, so you cannot use it for fixed pipeline programs.

Example
-------

Sample below taken from `tests/glSimple.lua` and does not do anything interesting. Peek into `tests/` folder for more samples.

```lua
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
```

License
-------

This software is distributed under MIT-like license:

#### Copyright (c) 2011-2012 Adam Strzelecki

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
