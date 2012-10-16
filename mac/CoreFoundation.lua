local ffi = require 'ffi'

ffi.cdef [[
typedef const void * CFTypeRef;
typedef const struct __CFString * CFStringRef;
typedef struct __CFString * CFMutableStringRef;
typedef const struct __CFAllocator * CFAllocatorRef;
typedef const struct __CFBundle * CFBundleRef;
typedef const struct __CFURL * CFURLRef;
typedef int Boolean;
typedef unsigned long CFTypeID;
typedef unsigned long CFOptionFlags;
typedef unsigned long CFHashCode;
typedef signed long CFIndex;

// CFType
CFTypeRef CFRetain(CFTypeRef cf);
void CFRelease(CFTypeRef cf);
const CFAllocatorRef kCFAllocatorDefault;

// CFString
typedef enum {
  CFStringEncodingMacRoman = 0,
  CFStringEncodingMacJapanese = 1,
  CFStringEncodingMacChineseTrad = 2,
  CFStringEncodingMacKorean = 3,
  CFStringEncodingMacArabic = 4,
  CFStringEncodingMacHebrew = 5,
  CFStringEncodingMacGreek = 6,
  CFStringEncodingMacCyrillic = 7,
  CFStringEncodingMacDevanagari = 9,
  CFStringEncodingMacGurmukhi = 10,
  CFStringEncodingMacGujarati = 11,
  CFStringEncodingMacOriya = 12,
  CFStringEncodingMacBengali = 13,
  CFStringEncodingMacTamil = 14,
  CFStringEncodingMacTelugu = 15,
  CFStringEncodingMacKannada = 16,
  CFStringEncodingMacMalayalam = 17,
  CFStringEncodingMacSinhalese = 18,
  CFStringEncodingMacBurmese = 19,
  CFStringEncodingMacKhmer = 20,
  CFStringEncodingMacThai = 21,
  CFStringEncodingMacLaotian = 22,
  CFStringEncodingMacGeorgian = 23,
  CFStringEncodingMacArmenian = 24,
  CFStringEncodingMacChineseSimp = 25,
  CFStringEncodingMacTibetan = 26,
  CFStringEncodingMacMongolian = 27,
  CFStringEncodingMacEthiopic = 28,
  CFStringEncodingMacCentralEurRoman = 29,
  CFStringEncodingMacVietnamese = 30,
  CFStringEncodingMacExtArabic = 31,
  CFStringEncodingMacSymbol = 33,
  CFStringEncodingMacDingbats = 34,
  CFStringEncodingMacTurkish = 35,
  CFStringEncodingMacCroatian = 36,
  CFStringEncodingMacIcelandic = 37,
  CFStringEncodingMacRomanian = 38,
  CFStringEncodingMacCeltic = 39,
  CFStringEncodingMacGaelic = 40,
  CFStringEncodingMacFarsi = 0x8C,
  CFStringEncodingMacUkrainian = 0x98,
  CFStringEncodingMacInuit = 0xEC,
  CFStringEncodingMacVT100 = 0xFC,
  CFStringEncodingMacHFS = 0xFF,
  CFStringEncodingISOLatin1 = 0x0201,
  CFStringEncodingISOLatin2 = 0x0202,
  CFStringEncodingISOLatin3 = 0x0203,
  CFStringEncodingISOLatin4 = 0x0204,
  CFStringEncodingISOLatinCyrillic = 0x0205,
  CFStringEncodingISOLatinArabic = 0x0206,
  CFStringEncodingISOLatinGreek = 0x0207,
  CFStringEncodingISOLatinHebrew = 0x0208,
  CFStringEncodingISOLatin5 = 0x0209,
  CFStringEncodingISOLatin6 = 0x020A,
  CFStringEncodingISOLatinThai = 0x020B,
  CFStringEncodingISOLatin7 = 0x020D,
  CFStringEncodingISOLatin8 = 0x020E,
  CFStringEncodingISOLatin9 = 0x020F,
  CFStringEncodingISOLatin10 = 0x0210,
  CFStringEncodingDOSLatinUS = 0x0400,
  CFStringEncodingDOSGreek = 0x0405,
  CFStringEncodingDOSBalticRim = 0x0406,
  CFStringEncodingDOSLatin1 = 0x0410,
  CFStringEncodingDOSGreek1 = 0x0411,
  CFStringEncodingDOSLatin2 = 0x0412,
  CFStringEncodingDOSCyrillic = 0x0413,
  CFStringEncodingDOSTurkish = 0x0414,
  CFStringEncodingDOSPortuguese = 0x0415,
  CFStringEncodingDOSIcelandic = 0x0416,
  CFStringEncodingDOSHebrew = 0x0417,
  CFStringEncodingDOSCanadianFrench = 0x0418,
  CFStringEncodingDOSArabic = 0x0419,
  CFStringEncodingDOSNordic = 0x041A,
  CFStringEncodingDOSRussian = 0x041B,
  CFStringEncodingDOSGreek2 = 0x041C,
  CFStringEncodingDOSThai = 0x041D,
  CFStringEncodingDOSJapanese = 0x0420,
  CFStringEncodingDOSChineseSimplif = 0x0421,
  CFStringEncodingDOSKorean = 0x0422,
  CFStringEncodingDOSChineseTrad = 0x0423,
  CFStringEncodingWindowsLatin1 = 0x0500,
  CFStringEncodingWindowsLatin2 = 0x0501,
  CFStringEncodingWindowsCyrillic = 0x0502,
  CFStringEncodingWindowsGreek = 0x0503,
  CFStringEncodingWindowsLatin5 = 0x0504,
  CFStringEncodingWindowsHebrew = 0x0505,
  CFStringEncodingWindowsArabic = 0x0506,
  CFStringEncodingWindowsBalticRim = 0x0507,
  CFStringEncodingWindowsVietnamese = 0x0508,
  CFStringEncodingWindowsKoreanJohab = 0x0510,
  CFStringEncodingASCII = 0x0600,
  CFStringEncodingANSEL = 0x0601,
  CFStringEncodingJIS_X0201_76 = 0x0620,
  CFStringEncodingJIS_X0208_83 = 0x0621,
  CFStringEncodingJIS_X0208_90 = 0x0622,
  CFStringEncodingJIS_X0212_90 = 0x0623,
  CFStringEncodingJIS_C6226_78 = 0x0624,
  CFStringEncodingShiftJIS_X0213 = 0x0628,
  CFStringEncodingShiftJIS_X0213_MenKuTen = 0x0629,
  CFStringEncodingGB_2312_80 = 0x0630,
  CFStringEncodingGBK_95 = 0x0631,
  CFStringEncodingGB_18030_2000 = 0x0632,
  CFStringEncodingKSC_5601_87 = 0x0640,
  CFStringEncodingKSC_5601_92_Johab = 0x0641,
  CFStringEncodingCNS_11643_92_P1 = 0x0651,
  CFStringEncodingCNS_11643_92_P2 = 0x0652,
  CFStringEncodingCNS_11643_92_P3 = 0x0653,
  CFStringEncodingISO_2022_JP = 0x0820,
  CFStringEncodingISO_2022_JP_2 = 0x0821,
  CFStringEncodingISO_2022_JP_1 = 0x0822,
  CFStringEncodingISO_2022_JP_3 = 0x0823,
  CFStringEncodingISO_2022_CN = 0x0830,
  CFStringEncodingISO_2022_CN_EXT = 0x0831,
  CFStringEncodingISO_2022_KR = 0x0840,
  CFStringEncodingEUC_JP = 0x0920,
  CFStringEncodingEUC_CN = 0x0930,
  CFStringEncodingEUC_TW = 0x0931,
  CFStringEncodingEUC_KR = 0x0940,
  CFStringEncodingShiftJIS = 0x0A01,
  CFStringEncodingKOI8_R = 0x0A02,
  CFStringEncodingBig5 = 0x0A03,
  CFStringEncodingMacRomanLatin1 = 0x0A04,
  CFStringEncodingHZ_GB_2312 = 0x0A05,
  CFStringEncodingBig5_HKSCS_1999 = 0x0A06,
  CFStringEncodingVISCII = 0x0A07,
  CFStringEncodingKOI8_U = 0x0A08,
  CFStringEncodingBig5_E = 0x0A09,
  CFStringEncodingNextStepLatin = 0x0B01,
  CFStringEncodingNextStepJapanese = 0x0B02,
  CFStringEncodingEBCDIC_US = 0x0C01,
  CFStringEncodingEBCDIC_CP037 = 0x0C02,
  CFStringEncodingUTF7 = 0x04000100,
  CFStringEncodingUTF7_IMAP = 0x0A10,
  CFStringEncodingShiftJIS_X0213_00 = 0x0628, /* Deprecated */
  CFStringEncodingUTF8 = 0x08000100
} CFStringEncoding;
CFStringRef CFStringCreateWithCString (
  CFAllocatorRef alloc,
  const char *cStr,
  CFStringEncoding encoding
);
CFIndex CFStringGetLength (
  CFStringRef theString
);
CFIndex CFStringGetMaximumSizeForEncoding (
  CFIndex length,
  CFStringEncoding encoding
);
const char * CFStringGetCStringPtr (
  CFStringRef theString,
  CFStringEncoding encoding
);
Boolean CFStringGetCString (
  CFStringRef theString,
  char *buffer,
  CFIndex bufferSize,
  CFStringEncoding encoding
);

// CFBundle
CFBundleRef CFBundleGetMainBundle (
  void
);
CFURLRef CFBundleCopyExecutableURL (
  CFBundleRef bundle
);
CFURLRef CFBundleCopyResourcesDirectoryURL (
  CFBundleRef bundle
);
CFURLRef CFBundleCopyResourceURL (
  CFBundleRef bundle,
  CFStringRef resourceName,
  CFStringRef resourceType,
  CFStringRef subDirName
);

// CFURL
typedef enum {
  CFURLPOSIXPathStyle = 0,
  CFURLHFSPathStyle = 1,
  CFURLWindowsPathStyle = 2
} CFURLPathStyle;
CFURLRef CFURLCreateWithFileSystemPath (
  CFAllocatorRef allocator,
  CFStringRef filePath,
  CFURLPathStyle pathStyle,
  Boolean isDirectory
);
CFURLRef CFURLCreateCopyAppendingPathComponent (
  CFAllocatorRef allocator,
  CFURLRef url,
  CFStringRef pathComponent,
  Boolean isDirectory
);
CFStringRef CFURLGetString (
  CFURLRef anURL
);
]]

-- setup library & remove CF prefix
local lib = ffi.load 'CoreFoundation.framework/CoreFoundation'
local cf  = { AllocatorDefault = lib.kCFAllocatorDefault }
setmetatable(cf, {
  __index = function(t, n)
    local s = lib['CF'..n]
    rawset(t, n, s)
    return s
  end
})

-- CFString
cf.CFStringRef = ffi.typeof('CFStringRef')
function cf.str(str)
  if str == nil then
   return nil
  end
  return ffi.gc(cf.StringCreateWithCString(
    cf.AllocatorDefault,
    str,
    cf.StringEncodingUTF8
  ), CFRelease)
end

-- CFURL
cf.CFURLRef   = ffi.typeof('CFURLRef')
cf.mainBundle = cf.BundleGetMainBundle()
function cf.ExecutableURL()
  return ffi.gc(cf.BundleCopyExecutableURL(cf.mainBundle), CFRelease)
end
function cf.ResourcesURL()
  return ffi.gc(cf.BundleCopyResourcesDirectoryURL(cf.mainBundle), CFRelease)
end
function cf.PathURL(path, isDir)
  isDir = isDir or false
  return ffi.gc(cf.URLCreateWithFileSystemPath(
    cf.AllocatorDefault,
    cf.str(path),
    cf.URLPOSIXPathStyle,
    isDir
  ), CFRelease)
end
function cf.ResourceURL(name, kind, dir)
  return ffi.gc(cf.BundleCopyResourceURL(
    cf.BundleGetMainBundle(),
    cf.str(name),
    cf.str(kind),
    cf.str(dir)
  ), CFRelease)
end
function cf.AppendURLComponent(cfurl, component, isDir)
  isDir = isDir or false
  return ffi.gc(cf.URLCreateCopyAppendingPathComponent(
    cf.AllocatorDefault,
    cfurl,
    cf.str(component),
    false
  ), CFRelease)
end

-- global type to string conversion function
function cf.tostring(cftype)
  if cftype == nil then
   return nil
  elseif ffi.istype(cf.CFURLRef, cftype) then
    return cf.tostring(cf.URLGetString(cftype))
  elseif ffi.istype(cf.CFStringRef, cftype) then
    local len = cf.StringGetLength(cftype)
    local clen = cf.StringGetMaximumSizeForEncoding(len, cf.StringEncodingUTF8)
    local cstr = ffi.new('char[?]', clen)
    cf.StringGetCString(cftype, cstr, clen, cf.StringEncodingUTF8)
    return ffi.string(cstr)
  end
  return nil
end

return cf
