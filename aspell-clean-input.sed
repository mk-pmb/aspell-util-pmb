#!/bin/sed -urf
# run with LANG=C
# -*- coding: UTF-8, tab-width: 2 -*-

# remove UTF-8 BOM:
1s~^\xEF\xBB\xBF~~
# to lowercase:
s~[A-Z]+~\L&\E~g

# strip ASCII control chars:
s~[\x00- \x7F]+~ ~g
# strip control chars U+0080…U+009F + soft hyphen:
s~\xC2[\x80-\x9F\xAD]~~g

# simplify unicode chars:
s!“|”|‹|›|«|»!"!g
s!’|´|`!'!g
s!–|—! -- !g

# cut out URLs:
s"\b[a-z]{1,8}(\+[a-z]{1,8}|)://[#!$%&*-;=?-z~]+" "g
s"\bmailto:[#!$%&*-;=?-z~]+" "g

# strip double quotes:
s~ *" *~ ~g

# de-parenthesise words:
s~\(([a-z])~\1~g
s~([a-z])\)~\1~g

# use space instead of nbsp + some other non-letters
s~(\xC2[\xA0-\xBF])+~ ~g

# punctuation that is forbidden inside words:
s~((\.|\!|\?|\:|\;|\,)+)~\a&\f~g
s~\f\a~~g
s~([a-z])(\a)~\1 \2~ig
s~(\f)([a-z])~\1 \2~ig

s~\a~ ~g
s~\s+~\n~g
