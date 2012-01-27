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
local iconvlib = ffi.load 'iconv'
local iconv = {}
setmetatable(iconv, {
  __index = function(t, n)
    local s = iconvlib['iconv_'..n]
    rawset(t, n, s)
    return s
  end
})

function iconv.iconv(ic, str)
  local len       = string.len(str)

  local inbuf     = ffi.new('char [?]', len)
  local inbufptr  = ffi.new('char *[1]')
  local insize    = ffi.new('size_t[1]')
  inbufptr[0]     = inbuf
  insize[0]       = len

  local outbuf    = ffi.new('char [?]', len*2)
  local outbufptr = ffi.new('char *[1]')
  local outsize   = ffi.new('size_t[1]')
  outbufptr[0]    = outbuf
  outsize[0]      = 2*len

  ffi.copy(inbuf, str)
  iconvlib.iconv(ic, inbufptr, insize, outbufptr, outsize)
  local outlen = 2*len - outsize[0]

  return ffi.string(outbuf, outlen), tonumber(outlen)
end

function iconv.iconv_uint16(ic, str)
  local len       = string.len(str)

  local inbuf     = ffi.new('char [?]', len)
  local inbufptr  = ffi.new('char *[1]')
  local insize    = ffi.new('size_t[1]')
  inbufptr[0]     = inbuf
  insize[0]       = len

  local outbuf    = ffi.new('uint16_t [?]', len)
  local outbufstr = ffi.cast('char *', outbuf)
  local outbufptr = ffi.new('char *[1]')
  local outsize   = ffi.new('size_t[1]')
  outbufptr[0]    = outbufstr
  outsize[0]      = 2*len

  ffi.copy(inbuf, str)
  iconvlib.iconv(ic, inbufptr, insize, outbufptr, outsize)
  local outlen = 2*len - outsize[0]

  return outbuf, tonumber(outlen / 2)
end

return iconv
