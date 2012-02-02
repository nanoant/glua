-- LuaJIT FFI adapted OpenGL Apple extensions
-- Created by: Adam Strzelecki http://www.nanoant.com/

local ffi = require 'ffi'

ffi.cdef [[
extern void glBindVertexArrayAPPLE(GLuint id);
extern void glDeleteVertexArraysAPPLE(GLsizei n, const GLuint *ids);
extern void glGenVertexArraysAPPLE(GLsizei n, GLuint *ids);
extern GLboolean glIsVertexArrayAPPLE(GLuint id);
]]
