-- Core iconv implenentation for LuaJIT FFI
--
-- Copyright (C) 1999-2003, 2005-2006 Free Software Foundation, Inc.
-- This file is part of the GNU LIBICONV Library.
--
-- The GNU LIBICONV Library is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Library General Public
-- License as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- The GNU LIBICONV Library is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Library General Public License for more details.
--
-- You should have received a copy of the GNU Library General Public
-- License along with the GNU LIBICONV Library; see the file COPYING.LIB.
-- If not, write to the Free Software Foundation, Inc., 51 Franklin Street,
-- Fifth Floor, Boston, MA 02110-1301, USA.

local ffi = require 'ffi'

ffi.cdef [[
extern  int _libiconv_version; /* Likewise */
typedef void* iconv_t;
iconv_t iconv_open (const char* /*tocode*/, const char* /*fromcode*/);
size_t iconv (iconv_t /*cd*/,
	char ** __restrict /*inbuf*/,  size_t * __restrict /*inbytesleft*/,
	char ** __restrict /*outbuf*/, size_t * __restrict /*outbytesleft*/);
int iconv_close (iconv_t /*cd*/);
]]

-- setup library & remove FT_ prefix
local lib   = ffi.load 'iconv'
local iconv = {}
setmetatable(iconv, {
  __index = function(t, n)
    local s = lib['iconv_'..n]
    rawset(t, n, s)
    return s
  end
})

local charptr = ffi.typeof('char *[1]')
local sizeptr = ffi.typeof('size_t[1]')
local chara   = ffi.typeof('char [?]')
local charp   = ffi.typeof('char *')
local uint16a = ffi.typeof('uint16_t [?]')

function iconv.iconv(ic, str, uint16)
  local len       = string.len(str)

  local insize    = sizeptr(len)
  local inbuf     = chara(len+1, str)
  local inbufptr  = charptr(inbuf)

  local outsize   = sizeptr(2*len)
  local outbuf, outbufptr
  if uint16 then
    outbuf        = uint16a(len)
    outbufptr     = charptr(ffi.cast(charp, outbuf))
  else
    outbuf        = chara(2*len)
    outbufptr     = charptr(outbuf)
  end

  lib.iconv(ic, inbufptr, insize, outbufptr, outsize)
  local outlen = 2*len - outsize[0]
  if uint16 then
    return outbuf, tonumber(outlen / 2)
  end
  return ffi.string(outbuf, outlen), outlen
end

return iconv
