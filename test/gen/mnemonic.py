#!/usr/bin/env python
#
# Copyright (c) 2013 Pavol Rusnak
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The code is inspired by Electrum mnemonic code by ThomasV
#

import binascii
import os

class Mnemonic(object):
	def __init__(self, language):
		self.radix = 2048
		self.wordlist = [w.strip() for w in open('%s/%s.txt' % (self._get_directory(), language), 'r').readlines()]
		if len(self.wordlist) != self.radix:
			raise Exception('Wordlist should contain %d words.' % self.radix)

	@classmethod
	def _get_directory(cls):
		return os.path.join(os.path.dirname(__file__), 'wordlist')

	@classmethod
	def list_languages(cls):
		return [ f.split('.')[0] for f in os.listdir(cls._get_directory()) if f.endswith('.txt') ]

	@classmethod
	def detect_language(cls, code):
		first = code.split(' ')[0]
		languages = cls.list_languages()

		for lang in languages:
			mnemo = cls(lang)
			if first in mnemo.wordlist:
				return lang

		raise Exception("Language not detected")

	def checksum(self, b):
		l = len(b) / 32
		c = 0
		for i in range(32):
			c ^= int(b[i * l:(i + 1) * l], 2)
		c = bin(c)[2:].zfill(l)
		return c

	def encode(self, data):
		if len(self.wordlist) != self.radix:
			raise Exception('Wordlist does not contain %d items!' % self.radix)
		if len(data) % 4 != 0:
			raise Exception('Data length not divisable by 4!')
		b = bin(int(binascii.hexlify(data), 16))[2:].zfill(len(data) * 8)
		assert len(b) % 32 == 0
		c = self.checksum(b)
		assert len(c) == len(b) / 32
		e = b + c
		assert len(e) % 33 == 0
		result = []
		for i in range(len(e) / 11):
			idx = int(e[i * 11:(i + 1) * 11], 2)
			result.append(self.wordlist[idx])
		return ' '.join(result)

def main():
    import sys
    if len(sys.argv) > 1:
        data = sys.argv[1]
    else:
        data = sys.stdin.readline().strip()
    data = binascii.unhexlify(data)
    m = Mnemonic('english')
    print(m.encode(data))

if __name__ == '__main__':
    main()
