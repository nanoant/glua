-- LuaJIT FFI adapted GLUT headers
-- Created by: Adam Strzelecki http://www.nanoant.com/
--
-- Copyright (c) Mark J. Kilgard, 1994, 1995, 1996, 1998.
--
-- This program is freely distributable without licensing fees  and is
-- provided without guarantee or warrantee expressed or  implied. This
-- program is -not- in the public domain.

local ffi = require 'ffi'

require 'gl.gl'
require 'gl.glu'

ffi.cdef[[
/* constants */
enum {

/* Display mode bit masks. */
  GLUT_RGB                        = 0,
  GLUT_RGBA                       = GLUT_RGB,
  GLUT_INDEX                      = 1,
  GLUT_SINGLE                     = 0,
  GLUT_DOUBLE                     = 2,
  GLUT_ACCUM                      = 4,
  GLUT_ALPHA                      = 8,
  GLUT_DEPTH                      = 16,
  GLUT_STENCIL                    = 32,
  GLUT_MULTISAMPLE                = 128,
  GLUT_STEREO                     = 256,
  GLUT_LUMINANCE                  = 512,
  GLUT_NO_RECOVERY                = 1024,

/* Mouse buttons. */
  GLUT_LEFT_BUTTON                = 0,
  GLUT_MIDDLE_BUTTON              = 1,
  GLUT_RIGHT_BUTTON               = 2,

/* Mouse button  state. */
  GLUT_DOWN                       = 0,
  GLUT_UP                         = 1,

/* function keys */
  GLUT_KEY_F1                     = 1,
  GLUT_KEY_F2                     = 2,
  GLUT_KEY_F3                     = 3,
  GLUT_KEY_F4                     = 4,
  GLUT_KEY_F5                     = 5,
  GLUT_KEY_F6                     = 6,
  GLUT_KEY_F7                     = 7,
  GLUT_KEY_F8                     = 8,
  GLUT_KEY_F9                     = 9,
  GLUT_KEY_F10                    = 10,
  GLUT_KEY_F11                    = 11,
  GLUT_KEY_F12                    = 12,
/* directional keys */
  GLUT_KEY_LEFT                   = 100,
  GLUT_KEY_UP                     = 101,
  GLUT_KEY_RIGHT                  = 102,
  GLUT_KEY_DOWN                   = 103,
  GLUT_KEY_PAGE_UP                = 104,
  GLUT_KEY_PAGE_DOWN              = 105,
  GLUT_KEY_HOME                   = 106,
  GLUT_KEY_END                    = 107,
  GLUT_KEY_INSERT                 = 108,

/* Entry/exit  state. */
  GLUT_LEFT                       = 0,
  GLUT_ENTERED                    = 1,

/* Menu usage  state. */
  GLUT_MENU_NOT_IN_USE            = 0,
  GLUT_MENU_IN_USE                = 1,

/* Visibility  state. */
  GLUT_NOT_VISIBLE                = 0,
  GLUT_VISIBLE                    = 1,

/* Window status  state. */
  GLUT_HIDDEN                     = 0,
  GLUT_FULLY_RETAINED             = 1,
  GLUT_PARTIALLY_RETAINED         = 2,
  GLUT_FULLY_COVERED              = 3,

/* Color index component selection values. */
  GLUT_RED                        = 0,
  GLUT_GREEN                      = 1,
  GLUT_BLUE                       = 2,

/* Layers for use. */
  GLUT_NORMAL                     = 0,
  GLUT_OVERLAY                    = 1,

/* Stroke font opaque addresses (use constants instead in source code). */
/* REMOVED */
/* Bitmap font opaque addresses (use constants instead in source code). */
/* REMOVED */

/* glutGet parameters. */
  GLUT_WINDOW_X                   = 100,
  GLUT_WINDOW_Y                   = 101,
  GLUT_WINDOW_WIDTH               = 102,
  GLUT_WINDOW_HEIGHT              = 103,
  GLUT_WINDOW_BUFFER_SIZE         = 104,
  GLUT_WINDOW_STENCIL_SIZE        = 105,
  GLUT_WINDOW_DEPTH_SIZE          = 106,
  GLUT_WINDOW_RED_SIZE            = 107,
  GLUT_WINDOW_GREEN_SIZE          = 108,
  GLUT_WINDOW_BLUE_SIZE           = 109,
  GLUT_WINDOW_ALPHA_SIZE          = 110,
  GLUT_WINDOW_ACCUM_RED_SIZE      = 111,
  GLUT_WINDOW_ACCUM_GREEN_SIZE    = 112,
  GLUT_WINDOW_ACCUM_BLUE_SIZE     = 113,
  GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 114,
  GLUT_WINDOW_DOUBLEBUFFER        = 115,
  GLUT_WINDOW_RGBA                = 116,
  GLUT_WINDOW_PARENT              = 117,
  GLUT_WINDOW_NUM_CHILDREN        = 118,
  GLUT_WINDOW_COLORMAP_SIZE       = 119,
  GLUT_WINDOW_NUM_SAMPLES         = 120,
  GLUT_WINDOW_STEREO              = 121,
  GLUT_WINDOW_CURSOR              = 122,
  GLUT_SCREEN_WIDTH               = 200,
  GLUT_SCREEN_HEIGHT              = 201,
  GLUT_SCREEN_WIDTH_MM            = 202,
  GLUT_SCREEN_HEIGHT_MM           = 203,
  GLUT_MENU_NUM_ITEMS             = 300,
  GLUT_DISPLAY_MODE_POSSIBLE      = 400,
  GLUT_INIT_WINDOW_X              = 500,
  GLUT_INIT_WINDOW_Y              = 501,
  GLUT_INIT_WINDOW_WIDTH          = 502,
  GLUT_INIT_WINDOW_HEIGHT         = 503,
  GLUT_INIT_DISPLAY_MODE          = 504,
  GLUT_ELAPSED_TIME               = 700,
  GLUT_WINDOW_FORMAT_ID           = 123,

/* glutDeviceGet parameters. */
  GLUT_HAS_KEYBOARD               = 600,
  GLUT_HAS_MOUSE                  = 601,
  GLUT_HAS_SPACEBALL              = 602,
  GLUT_HAS_DIAL_AND_BUTTON_BOX    = 603,
  GLUT_HAS_TABLET                 = 604,
  GLUT_NUM_MOUSE_BUTTONS          = 605,
  GLUT_NUM_SPACEBALL_BUTTONS      = 606,
  GLUT_NUM_BUTTON_BOX_BUTTONS     = 607,
  GLUT_NUM_DIALS                  = 608,
  GLUT_NUM_TABLET_BUTTONS         = 609,
  GLUT_DEVICE_IGNORE_KEY_REPEAT   = 610,
  GLUT_DEVICE_KEY_REPEAT          = 611,
  GLUT_HAS_JOYSTICK               = 612,
  GLUT_OWNS_JOYSTICK              = 613,
  GLUT_JOYSTICK_BUTTONS           = 614,
  GLUT_JOYSTICK_AXES              = 615,
  GLUT_JOYSTICK_POLL_RATE         = 616,

/* glutLayerGet parameters. */
  GLUT_OVERLAY_POSSIBLE           = 800,
  GLUT_LAYER_IN_USE               = 801,
  GLUT_HAS_OVERLAY                = 802,
  GLUT_TRANSPARENT_INDEX          = 803,
  GLUT_NORMAL_DAMAGED             = 804,
  GLUT_OVERLAY_DAMAGED            = 805,

/* glutVideoResizeGet parameters. */
  GLUT_VIDEO_RESIZE_POSSIBLE      = 900,
  GLUT_VIDEO_RESIZE_IN_USE        = 901,
  GLUT_VIDEO_RESIZE_X_DELTA       = 902,
  GLUT_VIDEO_RESIZE_Y_DELTA       = 903,
  GLUT_VIDEO_RESIZE_WIDTH_DELTA   = 904,
  GLUT_VIDEO_RESIZE_HEIGHT_DELTA  = 905,
  GLUT_VIDEO_RESIZE_X             = 906,
  GLUT_VIDEO_RESIZE_Y             = 907,
  GLUT_VIDEO_RESIZE_WIDTH         = 908,
  GLUT_VIDEO_RESIZE_HEIGHT        = 909,

/* glutUseLayer parameters. */
/*
  GLUT_NORMAL                     = 0,
  GLUT_OVERLAY                    = 1,
*/

/*
  GLUT_STROKE_ROMAN               = ((void*)0)
  GLUT_STROKE_MONO_ROMAN          = ((void*)1)
*/
/* Bitmap font constants (use these in GLUT program). */
/*
  GLUT_BITMAP_9_BY_15             = ((void*)2)
  GLUT_BITMAP_8_BY_13             = ((void*)3)
  GLUT_BITMAP_TIMES_ROMAN_10      = ((void*)4)
  GLUT_BITMAP_TIMES_ROMAN_24      = ((void*)5)
  GLUT_BITMAP_HELVETICA_10        = ((void*)6)
  GLUT_BITMAP_HELVETICA_12        = ((void*)7)
  GLUT_BITMAP_HELVETICA_18        = ((void*)8)
*/
/* glutGetModifiers return mask. */
  GLUT_ACTIVE_SHIFT               = 1,
  GLUT_ACTIVE_CTRL                = 2,
  GLUT_ACTIVE_ALT                 = 4,

/* glutSetCursor parameters. */
/* Basic arrows. */
  GLUT_CURSOR_RIGHT_ARROW         = 0,
  GLUT_CURSOR_LEFT_ARROW          = 1,
/* Symbolic cursor shapes. */
  GLUT_CURSOR_INFO                = 2,
  GLUT_CURSOR_DESTROY             = 3,
  GLUT_CURSOR_HELP                = 4,
  GLUT_CURSOR_CYCLE               = 5,
  GLUT_CURSOR_SPRAY               = 6,
  GLUT_CURSOR_WAIT                = 7,
  GLUT_CURSOR_TEXT                = 8,
  GLUT_CURSOR_CROSSHAIR           = 9,
/* Directional cursors. */
  GLUT_CURSOR_UP_DOWN             = 10,
  GLUT_CURSOR_LEFT_RIGHT          = 11,
/* Sizing cursors. */
  GLUT_CURSOR_TOP_SIDE            = 12,
  GLUT_CURSOR_BOTTOM_SIDE         = 13,
  GLUT_CURSOR_LEFT_SIDE           = 14,
  GLUT_CURSOR_RIGHT_SIDE          = 15,
  GLUT_CURSOR_TOP_LEFT_CORNER     = 16,
  GLUT_CURSOR_TOP_RIGHT_CORNER    = 17,
  GLUT_CURSOR_BOTTOM_RIGHT_CORNER = 18,
  GLUT_CURSOR_BOTTOM_LEFT_CORNER  = 19,
/* Inherit from parent window. */
  GLUT_CURSOR_INHERIT             = 100,
/* Blank cursor. */
  GLUT_CURSOR_NONE                = 101,
/* Fullscreen crosshair (if available). */
  GLUT_CURSOR_FULL_CROSSHAIR      = 102,
};

/* GLUT initialization sub-API. */
void glutInit(int *argcp, char **argv);
void glutInitDisplayMode(unsigned int mode);
void glutInitDisplayString(const char *string);
void glutInitWindowPosition(int x, int y);
void glutInitWindowSize(int width, int height);
void glutMainLoop(void);

/* GLUT window sub-API. */
int glutCreateWindow(const char *title);
int glutCreateSubWindow(int win, int x, int y, int width, int height);
void glutDestroyWindow(int win);
void glutPostRedisplay(void);
void glutPostWindowRedisplay(int win);
void glutSwapBuffers(void);
int glutGetWindow(void);
void glutSetWindow(int win);
void glutSetWindowTitle(const char *title);
void glutSetIconTitle(const char *title);
void glutPositionWindow(int x, int y);
void glutReshapeWindow(int width, int height);
void glutPopWindow(void);
void glutPushWindow(void);
void glutIconifyWindow(void);
void glutShowWindow(void);
void glutHideWindow(void);
void glutFullScreen(void);
void glutSetCursor(int cursor);
void glutWarpPointer(int x, int y);
/* surface texturing API Mac OS X specific
*  Note:
*       glutSurfaceTexture has been deprecated, use GL_EXT_framebuffer_object
*/
void glutSurfaceTexture (GLenum target, GLenum internalformat, int surfacewin);
/* Mac OS X specific API */
void glutWMCloseFunc(void (*func)(void));
void glutCheckLoop(void);

/* GLUT overlay sub-API. */
void glutEstablishOverlay(void);
void glutRemoveOverlay(void);
void glutUseLayer(GLenum layer);
void glutPostOverlayRedisplay(void);
void glutPostWindowOverlayRedisplay(int win);
void glutShowOverlay(void);
void glutHideOverlay(void);

/* GLUT menu sub-API. */
int glutCreateMenu(void (*)(int));
void glutDestroyMenu(int menu);
int glutGetMenu(void);
void glutSetMenu(int menu);
void glutAddMenuEntry(const char *label, int value);
void glutAddSubMenu(const char *label, int submenu);
void glutChangeToMenuEntry(int item, const char *label, int value);
void glutChangeToSubMenu(int item, const char *label, int submenu);
void glutRemoveMenuItem(int item);
void glutAttachMenu(int button);
void glutDetachMenu(int button);

/* GLUT window callback sub-API. */
void glutDisplayFunc(void (*func)(void));
void glutReshapeFunc(void (*func)(int width, int height));
void glutKeyboardFunc(void (*func)(unsigned char key, int x, int y));
void glutMouseFunc(void (*func)(int button, int state, int x, int y));
void glutMotionFunc(void (*func)(int x, int y));
void glutPassiveMotionFunc(void (*func)(int x, int y));
void glutEntryFunc(void (*func)(int state));
void glutVisibilityFunc(void (*func)(int state));
void glutIdleFunc(void (*func)(void));
void glutTimerFunc(unsigned int millis, void (*func)(int value), int value);
void glutMenuStateFunc(void (*func)(int state));
void glutSpecialFunc(void (*func)(int key, int x, int y));
void glutSpaceballMotionFunc(void (*func)(int x, int y, int z));
void glutSpaceballRotateFunc(void (*func)(int x, int y, int z));
void glutSpaceballButtonFunc(void (*func)(int button, int state));
void glutButtonBoxFunc(void (*func)(int button, int state));
void glutDialsFunc(void (*func)(int dial, int value));
void glutTabletMotionFunc(void (*func)(int x, int y));
void glutTabletButtonFunc(void (*func)(int button, int state, int x, int y));
void glutMenuStatusFunc(void (*func)(int status, int x, int y));
void glutOverlayDisplayFunc(void (*func)(void));
void glutWindowStatusFunc(void (*func)(int state));
void glutKeyboardUpFunc(void (*func)(unsigned char key, int x, int y));
void glutSpecialUpFunc(void (*func)(int key, int x, int y));
void glutJoystickFunc(void (*func)(unsigned int buttonMask, int x, int y, int z), int pollInterval);

/* GLUT color index sub-API. */
void glutSetColor(int, GLfloat red, GLfloat green, GLfloat blue);
GLfloat glutGetColor(int ndx, int component);
void glutCopyColormap(int win);

/* GLUT state retrieval sub-API. */
int glutGet(GLenum type);
int glutDeviceGet(GLenum type);
/* GLUT extension support sub-API */
int glutExtensionSupported(const char *name);
int glutGetModifiers(void);
int glutLayerGet(GLenum type);
void * glutGetProcAddress(const char *procName);

/* GLUT font sub-API */
void glutBitmapCharacter(void *font, int character);
int glutBitmapWidth(void *font, int character);
void glutStrokeCharacter(void *font, int character);
int glutStrokeWidth(void *font, int character);
int glutBitmapLength(void *font, const unsigned char *string);
int glutStrokeLength(void *font, const unsigned char *string);

/* GLUT pre-built models sub-API */
void glutWireSphere(GLdouble radius, GLint slices, GLint stacks);
void glutSolidSphere(GLdouble radius, GLint slices, GLint stacks);
void glutWireCone(GLdouble base, GLdouble height, GLint slices, GLint stacks);
void glutSolidCone(GLdouble base, GLdouble height, GLint slices, GLint stacks);
void glutWireCube(GLdouble size);
void glutSolidCube(GLdouble size);
void glutWireTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
void glutSolidTorus(GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings);
void glutWireDodecahedron(void);
void glutSolidDodecahedron(void);
void glutWireTeapot(GLdouble size);
void glutSolidTeapot(GLdouble size);
void glutWireOctahedron(void);
void glutSolidOctahedron(void);
void glutWireTetrahedron(void);
void glutSolidTetrahedron(void);
void glutWireIcosahedron(void);
void glutSolidIcosahedron(void);

/* GLUT video resize sub-API. */
int glutVideoResizeGet(GLenum param);
void glutSetupVideoResizing(void);
void glutStopVideoResizing(void);
void glutVideoResize(int x, int y, int width, int height);
void glutVideoPan(int x, int y, int width, int height);

/* GLUT debugging sub-API. */
void glutReportErrors(void);

/* GLUT device control sub-API. */
enum {
/* glutSetKeyRepeat modes. */
  GLUT_KEY_REPEAT_OFF             = 0,
  GLUT_KEY_REPEAT_ON              = 1,
  GLUT_KEY_REPEAT_DEFAULT         = 2,

/* Joystick button masks. */
  GLUT_JOYSTICK_BUTTON_A          = 1,
  GLUT_JOYSTICK_BUTTON_B          = 2,
  GLUT_JOYSTICK_BUTTON_C          = 4,
  GLUT_JOYSTICK_BUTTON_D          = 8,
};

void glutIgnoreKeyRepeat(int ignore);
void glutSetKeyRepeat(int repeatMode);
void glutForceJoystickFunc(void);

/* GLUT game mode sub-API. */
enum {
/* glutGameModeGet. */
  GLUT_GAME_MODE_ACTIVE           = 0,
  GLUT_GAME_MODE_POSSIBLE         = 1,
  GLUT_GAME_MODE_WIDTH            = 2,
  GLUT_GAME_MODE_HEIGHT           = 3,
  GLUT_GAME_MODE_PIXEL_DEPTH      = 4,
  GLUT_GAME_MODE_REFRESH_RATE     = 5,
  GLUT_GAME_MODE_DISPLAY_CHANGED  = 6,
};

void glutGameModeString(const char *string);
int glutEnterGameMode(void);
void glutLeaveGameMode(void);
int glutGameModeGet(GLenum mode);
]]

local glut = ffi.load(ffi.os == 'OSX' and 'GLUT.framework/GLUT' or 'glut')

-- initialize GLUT
local name = arg[0]
local arg0 = ffi.new("char[?]", #name+1, name)
local argv = ffi.new("char *[1]", arg0)
local argcp = ffi.new("int[1]", 1)

glut.glutInit(argcp, argv)

return glut
