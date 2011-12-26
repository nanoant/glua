local cf  = require 'mac.CoreFoundation'
local ffi = require 'ffi'
local cg = ffi.load 'ApplicationServices.framework/ApplicationServices'

ffi.cdef [[
void *malloc(size_t size);
void free(void *);

typedef void *CGDataProviderRef;
typedef void *CGImageRef;
typedef void *CGColorSpaceRef;
typedef void *CGContextRef;
typedef double CGFloat;
typedef struct {
  CGFloat x;
  CGFloat y;
  CGFloat width;
  CGFloat height;
} CGRect;

// CGDataProvider
void CGDataProviderRelease (
  CGDataProviderRef provider
);
CGDataProviderRef CGDataProviderCreateWithURL (
  CFURLRef url
);

// CGColorSpace
CGColorSpaceRef CGColorSpaceCreateDeviceRGB();
void CGColorSpaceRelease (
  CGColorSpaceRef colorSpace
);

// CGContext
void CGContextRelease (
  CGContextRef c
);
void CGContextDrawImage (
  CGContextRef c,
  CGRect rect,
  CGImageRef image
);
void CGContextClearRect (
  CGContextRef c,
  CGRect rect
);

// CGBitmapContext
enum {
  kCGBitmapAlphaInfoMask = 0x1F,
  kCGBitmapFloatComponents = (1 << 8),
  kCGBitmapByteOrderMask = 0x7000,
  kCGBitmapByteOrderDefault = (0 << 12),
  kCGBitmapByteOrder16Little = (1 << 12),
  kCGBitmapByteOrder32Little = (2 << 12),
  kCGBitmapByteOrder16Big = (3 << 12),
  kCGBitmapByteOrder32Big = (4 << 12)
};
typedef uint32_t CGBitmapInfo;
typedef enum {
  kCGImageAlphaNone,
  kCGImageAlphaPremultipliedLast,
  kCGImageAlphaPremultipliedFirst,
  kCGImageAlphaLast,
  kCGImageAlphaFirst,
  kCGImageAlphaNoneSkipLast,
  kCGImageAlphaNoneSkipFirst
} CGImageAlphaInfo;
CGContextRef CGBitmapContextCreate (
  void *data,
  size_t width,
  size_t height,
  size_t bitsPerComponent,
  size_t bytesPerRow,
  CGColorSpaceRef colorspace,
  CGBitmapInfo bitmapInfo
);
void * CGBitmapContextGetData (
  CGContextRef c
);

// CGImage
typedef enum {
  kCGRenderingIntentDefault,
  kCGRenderingIntentAbsoluteColorimetric,
  kCGRenderingIntentRelativeColorimetric,
  kCGRenderingIntentPerceptual,
  kCGRenderingIntentSaturation
} CGColorRenderingIntent;
void CGImageRelease (
  CGImageRef image
);
CGImageRef CGImageCreateCopyWithColorSpace (
  CGImageRef image,
  CGColorSpaceRef colorspace
);
CGImageRef CGImageCreateWithPNGDataProvider (
  CGDataProviderRef source,
  const CGFloat decode[],
  bool shouldInterpolate,
  CGColorRenderingIntent intent
);
size_t CGImageGetBitsPerComponent (
  CGImageRef image
);
size_t CGImageGetBitsPerPixel (
  CGImageRef image
);
size_t CGImageGetBytesPerRow (
  CGImageRef image
);
size_t CGImageGetWidth (
  CGImageRef image
);
size_t CGImageGetHeight (
  CGImageRef image
);
]]

local M = {}

M.rect = ffi.typeof('CGRect')

-- CGDataProvider
function M.dataProvider(cfurl)
  return ffi.gc(cg.CGDataProviderCreateWithURL(cfurl), cg.CGDataProviderRelease)
end

-- CGImage
function M.imageFromPNGDataProvider(cgdp)
  return ffi.gc(cg.CGImageCreateWithPNGDataProvider(
    cgdp,
    nil,
    true,
    cg.kCGRenderingIntentDefault
  ), CGImageRelease)
end
function M.image(path)
  local url = ffi.istype(cf.CFURLRef, path) and path or cf.pathURL(path)
  if url == nil then return nil end
  local dp = M.dataProvider(url)
  if dp == nil then return nil end
  return M.imageFromPNGDataProvider(dp)
end
function M.imagePitch(cfimg)
  return tonumber(cg.CGImageGetBytesPerRow(cfimg))
end
function M.imageBPC(cfimg)
  return tonumber(cg.CGImageGetBitsPerComponent(cfimg))
end
function M.imageBPP(cfimg)
  return tonumber(cg.CGImageGetBitsPerPixel(cfimg))
end
function M.imageWidth(cfimg)
  return tonumber(cg.CGImageGetWidth(cfimg))
end
function M.imageHeight(cfimg)
  return tonumber(cg.CGImageGetHeight(cfimg))
end

-- CGBitmapContext
function M.bitmapFromImage(cfimg)
  if cfimg == nil then return nil end
  local width      = M.imageWidth(cfimg)
  local height     = M.imageHeight(cfimg)
  local pitch      = 4 * width
  local bitmapBuf  = ffi.new('uint8_t[?]', height * pitch)
  local colorSpace = ffi.gc(cg.CGColorSpaceCreateDeviceRGB(), cg.CGColorSpaceRelease)
  local bitmapCtx  = ffi.gc(cg.CGBitmapContextCreate(
    bitmapBuf,
    width, 
    height, 
    8, 
    pitch, 
    colorSpace, 
    cg.kCGImageAlphaPremultipliedLast
  ), cg.CGContextRelease)
  if bitmapCtx == nil then return nil end
  local rect = M.rect(0, 0, width, height)
  cg.CGContextDrawImage(bitmapCtx, rect, cfimg)
  return bitmapBuf, width, height, 4
end
function M.bitmap(path)
  local cfimg = M.image(path)
  if cfimg == nil then return nil end
  return M.bitmapFromImage(cfimg)
end

setmetatable(M, { __index = cg })

return M
