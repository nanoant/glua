local ffi = require 'ffi'
local cf = ffi.load 'CoreFoundation.framework/CoreFoundation'

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

// CFString
const CFAllocatorRef kCFAllocatorDefault;
const CFAllocatorRef kCFAllocatorSystemDefault;
const CFAllocatorRef kCFAllocatorMalloc;
const CFAllocatorRef kCFAllocatorMallocZone;
const CFAllocatorRef kCFAllocatorNull;
const CFAllocatorRef kCFAllocatorUseContext;

typedef enum {
  kCFStringEncodingMacRoman = 0L,
  kCFStringEncodingMacJapanese = 1,
  kCFStringEncodingMacChineseTrad = 2,
  kCFStringEncodingMacKorean = 3,
  kCFStringEncodingMacArabic = 4,
  kCFStringEncodingMacHebrew = 5,
  kCFStringEncodingMacGreek = 6,
  kCFStringEncodingMacCyrillic = 7,
  kCFStringEncodingMacDevanagari = 9,
  kCFStringEncodingMacGurmukhi = 10,
  kCFStringEncodingMacGujarati = 11,
  kCFStringEncodingMacOriya = 12,
  kCFStringEncodingMacBengali = 13,
  kCFStringEncodingMacTamil = 14,
  kCFStringEncodingMacTelugu = 15,
  kCFStringEncodingMacKannada = 16,
  kCFStringEncodingMacMalayalam = 17,
  kCFStringEncodingMacSinhalese = 18,
  kCFStringEncodingMacBurmese = 19,
  kCFStringEncodingMacKhmer = 20,
  kCFStringEncodingMacThai = 21,
  kCFStringEncodingMacLaotian = 22,
  kCFStringEncodingMacGeorgian = 23,
  kCFStringEncodingMacArmenian = 24,
  kCFStringEncodingMacChineseSimp = 25,
  kCFStringEncodingMacTibetan = 26,
  kCFStringEncodingMacMongolian = 27,
  kCFStringEncodingMacEthiopic = 28,
  kCFStringEncodingMacCentralEurRoman = 29,
  kCFStringEncodingMacVietnamese = 30,
  kCFStringEncodingMacExtArabic = 31,
  kCFStringEncodingMacSymbol = 33,
  kCFStringEncodingMacDingbats = 34,
  kCFStringEncodingMacTurkish = 35,
  kCFStringEncodingMacCroatian = 36,
  kCFStringEncodingMacIcelandic = 37,
  kCFStringEncodingMacRomanian = 38,
  kCFStringEncodingMacCeltic = 39,
  kCFStringEncodingMacGaelic = 40,
  kCFStringEncodingMacFarsi = 0x8C,
  kCFStringEncodingMacUkrainian = 0x98,
  kCFStringEncodingMacInuit = 0xEC,
  kCFStringEncodingMacVT100 = 0xFC,
  kCFStringEncodingMacHFS = 0xFF,
  kCFStringEncodingISOLatin1 = 0x0201,
  kCFStringEncodingISOLatin2 = 0x0202,
  kCFStringEncodingISOLatin3 = 0x0203,
  kCFStringEncodingISOLatin4 = 0x0204,
  kCFStringEncodingISOLatinCyrillic = 0x0205,
  kCFStringEncodingISOLatinArabic = 0x0206,
  kCFStringEncodingISOLatinGreek = 0x0207,
  kCFStringEncodingISOLatinHebrew = 0x0208,
  kCFStringEncodingISOLatin5 = 0x0209,
  kCFStringEncodingISOLatin6 = 0x020A,
  kCFStringEncodingISOLatinThai = 0x020B,
  kCFStringEncodingISOLatin7 = 0x020D,
  kCFStringEncodingISOLatin8 = 0x020E,
  kCFStringEncodingISOLatin9 = 0x020F,
  kCFStringEncodingISOLatin10 = 0x0210,
  kCFStringEncodingDOSLatinUS = 0x0400,
  kCFStringEncodingDOSGreek = 0x0405,
  kCFStringEncodingDOSBalticRim = 0x0406,
  kCFStringEncodingDOSLatin1 = 0x0410,
  kCFStringEncodingDOSGreek1 = 0x0411,
  kCFStringEncodingDOSLatin2 = 0x0412,
  kCFStringEncodingDOSCyrillic = 0x0413,
  kCFStringEncodingDOSTurkish = 0x0414,
  kCFStringEncodingDOSPortuguese = 0x0415,
  kCFStringEncodingDOSIcelandic = 0x0416,
  kCFStringEncodingDOSHebrew = 0x0417,
  kCFStringEncodingDOSCanadianFrench = 0x0418,
  kCFStringEncodingDOSArabic = 0x0419,
  kCFStringEncodingDOSNordic = 0x041A,
  kCFStringEncodingDOSRussian = 0x041B,
  kCFStringEncodingDOSGreek2 = 0x041C,
  kCFStringEncodingDOSThai = 0x041D,
  kCFStringEncodingDOSJapanese = 0x0420,
  kCFStringEncodingDOSChineseSimplif = 0x0421,
  kCFStringEncodingDOSKorean = 0x0422,
  kCFStringEncodingDOSChineseTrad = 0x0423,
  kCFStringEncodingWindowsLatin1 = 0x0500,
  kCFStringEncodingWindowsLatin2 = 0x0501,
  kCFStringEncodingWindowsCyrillic = 0x0502,
  kCFStringEncodingWindowsGreek = 0x0503,
  kCFStringEncodingWindowsLatin5 = 0x0504,
  kCFStringEncodingWindowsHebrew = 0x0505,
  kCFStringEncodingWindowsArabic = 0x0506,
  kCFStringEncodingWindowsBalticRim = 0x0507,
  kCFStringEncodingWindowsVietnamese = 0x0508,
  kCFStringEncodingWindowsKoreanJohab = 0x0510,
  kCFStringEncodingASCII = 0x0600,
  kCFStringEncodingANSEL = 0x0601,
  kCFStringEncodingJIS_X0201_76 = 0x0620,
  kCFStringEncodingJIS_X0208_83 = 0x0621,
  kCFStringEncodingJIS_X0208_90 = 0x0622,
  kCFStringEncodingJIS_X0212_90 = 0x0623,
  kCFStringEncodingJIS_C6226_78 = 0x0624,
  kCFStringEncodingShiftJIS_X0213 = 0x0628,
  kCFStringEncodingShiftJIS_X0213_MenKuTen = 0x0629,
  kCFStringEncodingGB_2312_80 = 0x0630,
  kCFStringEncodingGBK_95 = 0x0631,
  kCFStringEncodingGB_18030_2000 = 0x0632,
  kCFStringEncodingKSC_5601_87 = 0x0640,
  kCFStringEncodingKSC_5601_92_Johab = 0x0641,
  kCFStringEncodingCNS_11643_92_P1 = 0x0651,
  kCFStringEncodingCNS_11643_92_P2 = 0x0652,
  kCFStringEncodingCNS_11643_92_P3 = 0x0653,
  kCFStringEncodingISO_2022_JP = 0x0820,
  kCFStringEncodingISO_2022_JP_2 = 0x0821,
  kCFStringEncodingISO_2022_JP_1 = 0x0822,
  kCFStringEncodingISO_2022_JP_3 = 0x0823,
  kCFStringEncodingISO_2022_CN = 0x0830,
  kCFStringEncodingISO_2022_CN_EXT = 0x0831,
  kCFStringEncodingISO_2022_KR = 0x0840,
  kCFStringEncodingEUC_JP = 0x0920,
  kCFStringEncodingEUC_CN = 0x0930,
  kCFStringEncodingEUC_TW = 0x0931,
  kCFStringEncodingEUC_KR = 0x0940,
  kCFStringEncodingShiftJIS = 0x0A01,
  kCFStringEncodingKOI8_R = 0x0A02,
  kCFStringEncodingBig5 = 0x0A03,
  kCFStringEncodingMacRomanLatin1 = 0x0A04,
  kCFStringEncodingHZ_GB_2312 = 0x0A05,
  kCFStringEncodingBig5_HKSCS_1999 = 0x0A06,
  kCFStringEncodingVISCII = 0x0A07,
  kCFStringEncodingKOI8_U = 0x0A08,
  kCFStringEncodingBig5_E = 0x0A09,
  kCFStringEncodingNextStepLatin = 0x0B01,
  kCFStringEncodingNextStepJapanese = 0x0B02,
  kCFStringEncodingEBCDIC_US = 0x0C01,
  kCFStringEncodingEBCDIC_CP037 = 0x0C02,
  kCFStringEncodingUTF7 = 0x04000100,
  kCFStringEncodingUTF7_IMAP = 0x0A10,
  kCFStringEncodingShiftJIS_X0213_00 = 0x0628, /* Deprecated */
  kCFStringEncodingUTF8 = 0x08000100
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
  kCFURLPOSIXPathStyle = 0,
  kCFURLHFSPathStyle = 1,
  kCFURLWindowsPathStyle = 2
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

local M = {}

-- CFString
M.CFStringRef = ffi.typeof('CFStringRef')
function M.str(str)
  if str == nil then
   return nil
  end
  return ffi.gc(cf.CFStringCreateWithCString(
    cf.kCFAllocatorDefault,
    str,
    cf.kCFStringEncodingUTF8
  ), CFRelease)
end

-- CFURL
M.CFURLRef   = ffi.typeof('CFURLRef')
M.mainBundle = cf.CFBundleGetMainBundle()
function M.executableURL()
  return ffi.gc(cf.CFBundleCopyExecutableURL(M.mainBundle), CFRelease)
end
function M.resourcesURL()
  return ffi.gc(cf.CFBundleCopyResourcesDirectoryURL(M.mainBundle), CFRelease)
end
function M.pathURL(path, isDir)
  isDir = isDir or false
  return ffi.gc(cf.CFURLCreateWithFileSystemPath(
    cf.kCFAllocatorDefault,
    M.str(path),
    cf.kCFURLPOSIXPathStyle,
    isDir
  ), CFRelease)
end
function M.resourceURL(name, kind, dir)
  return ffi.gc(cf.CFBundleCopyResourceURL(
    cf.CFBundleGetMainBundle(),
    M.str(name),
    M.str(kind),
    M.str(dir)
  ), CFRelease)
end
function M.appendURLComponent(cfurl, component, isDir)
  isDir = isDir or false
  return ffi.gc(cf.CFURLCreateCopyAppendingPathComponent(
    cf.kCFAllocatorDefault,
    cfurl,
    M.str(component),
    false
  ), CFRelease)
end

-- global type to string conversion function
function M.tostring(cftype)
  if cftype == nil then
   return nil
  elseif ffi.istype(M.CFURLRef, cftype) then
    return M.tostring(cf.CFURLGetString(cftype))
  elseif ffi.istype(M.CFStringRef, cftype) then
    local len = cf.CFStringGetLength(cftype)
    local clen = cf.CFStringGetMaximumSizeForEncoding(len, cf.kCFStringEncodingUTF8)
    local cstr = ffi.new('char[?]', clen)
    cf.CFStringGetCString(cftype, cstr, clen, cf.kCFStringEncodingUTF8)
    return ffi.string(cstr)
  end
  return nil
end

setmetatable(M, { __index = cf })

return M