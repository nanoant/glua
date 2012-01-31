local cf  = require 'mac.CoreFoundation'
local ffi = require 'ffi'

ffi.cdef [[
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
  CGBitmapAlphaInfoMask = 0x1F,
  CGBitmapFloatComponents = (1 << 8),
  CGBitmapByteOrderMask = 0x7000,
  CGBitmapByteOrderDefault = (0 << 12),
  CGBitmapByteOrder16Little = (1 << 12),
  CGBitmapByteOrder32Little = (2 << 12),
  CGBitmapByteOrder16Big = (3 << 12),
  CGBitmapByteOrder32Big = (4 << 12)
};
typedef uint32_t CGBitmapInfo;
typedef enum {
  CGImageAlphaNone,
  CGImageAlphaPremultipliedLast,
  CGImageAlphaPremultipliedFirst,
  CGImageAlphaLast,
  CGImageAlphaFirst,
  CGImageAlphaNoneSkipLast,
  CGImageAlphaNoneSkipFirst
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
  CGRenderingIntentDefault,
  CGRenderingIntentAbsoluteColorimetric,
  CGRenderingIntentRelativeColorimetric,
  CGRenderingIntentPerceptual,
  CGRenderingIntentSaturation
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

-- setup library & remove CF prefix
local lib = ffi.load 'ApplicationServices.framework/ApplicationServices'
local cg  = { Rect = ffi.typeof('CGRect') }
setmetatable(cg, {
  __index = function(t, n)
    local s = lib['CG'..n]
    rawset(t, n, s)
    return s
  end
})

-- CGDataProvider
function cg.DataProvider(cfurl)
  return ffi.gc(cg.DataProviderCreateWithURL(cfurl), cg.DataProviderRelease)
end

-- CGImage
function cg.ImageFromPNGDataProvider(cgdp)
  return ffi.gc(cg.ImageCreateWithPNGDataProvider(
    cgdp,
    nil,
    true,
    cg.RenderingIntentDefault
  ), CGImageRelease)
end
function cg.Image(path)
  local url = ffi.istype(cf.CFURLRef, path) and path or cf.PathURL(path)
  if url == nil then return nil end
  local dp = cg.DataProvider(url)
  if dp == nil then return nil end
  return cg.ImageFromPNGDataProvider(dp)
end
function cg.ImagePitch(cfimg)
  return tonumber(cg.ImageGetBytesPerRow(cfimg))
end
function cg.ImageBPC(cfimg)
  return tonumber(cg.ImageGetBitsPerComponent(cfimg))
end
function cg.ImageBPP(cfimg)
  return tonumber(cg.ImageGetBitsPerPixel(cfimg))
end
function cg.ImageWidth(cfimg)
  return tonumber(cg.ImageGetWidth(cfimg))
end
function cg.ImageHeight(cfimg)
  return tonumber(cg.ImageGetHeight(cfimg))
end

-- CGBitmapContext
function cg.BitmapFromImage(cfimg)
  if cfimg == nil then return nil end
  local width      = cg.ImageWidth(cfimg)
  local height     = cg.ImageHeight(cfimg)
  local pitch      = 4 * width
  local bitmapBuf  = ffi.new('uint8_t[?]', height * pitch)
  local colorSpace = ffi.gc(cg.ColorSpaceCreateDeviceRGB(), cg.ColorSpaceRelease)
  local bitmapCtx  = ffi.gc(cg.BitmapContextCreate(
    bitmapBuf,
    width, 
    height, 
    8, 
    pitch, 
    colorSpace, 
    cg.ImageAlphaPremultipliedLast
  ), cg.ContextRelease)
  if bitmapCtx == nil then return nil end
  local rect = cg.Rect(0, 0, width, height)
  cg.ContextDrawImage(bitmapCtx, rect, cfimg)
  return bitmapBuf, width, height, 4
end
function cg.Bitmap(path)
  local cfimg = cg.Image(path)
  if cfimg == nil then return nil end
  return cg.BitmapFromImage(cfimg)
end

return cg
