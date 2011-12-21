local g = require('glua')

g.glutInitDisplayMode(
  g.GLUT_RGBA +
  g.GLUT_DOUBLE +
  g.GLUT_DEPTH +
  g.GLUT_MULTISAMPLE)

g.glutInitWindowSize(500, 500)
g.glutInitWindowPosition(100, 100)
g.glutCreateWindow("Test")
             
print('GL_VENDOR: '..g.glGetString(g.GL_VENDOR))
print('GL_RENDERER: '..g.glGetString(g.GL_RENDERER))
print('GL_VERSION: '..g.glGetString(g.GL_VERSION))
print('GL_SHADING_LANGUAGE_VERSION: '..g.glGetString(g.GL_SHADING_LANGUAGE_VERSION))

print()
print('GL_ALPHA_BITS='..g.glGet(g.GL_ALPHA_BITS))
print('GL_ARRAY_BUFFER_BINDING='..g.glGet(g.GL_ARRAY_BUFFER_BINDING))
print('GL_BLEND_COLOR='..g.glGet(g.GL_BLEND_COLOR)[3])
print('GL_SAMPLE_BUFFERS='..g.glGet(g.GL_SAMPLE_BUFFERS))
print('GL_MAX_3D_TEXTURE_SIZE='..g.glGet(g.GL_MAX_3D_TEXTURE_SIZE))
print('GL_MAX_LIGHTS='..g.glGet(g.GL_MAX_LIGHTS))
print('GL_MAX_TEXTURE_IMAGE_UNITS='..g.glGet(g.GL_MAX_TEXTURE_IMAGE_UNITS))
print('GL_MAX_TEXTURE_SIZE='..g.glGet(g.GL_MAX_TEXTURE_SIZE))
print('GL_MAX_VERTEX_UNIFORM_COMPONENTS='..g.glGet(g.GL_MAX_VERTEX_UNIFORM_COMPONENTS))

print()
print('GL_EXTENSIONS: '..g.glGetString(g.GL_EXTENSIONS))
