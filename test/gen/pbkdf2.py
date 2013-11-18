#!/usr/bin/env python

from Crypto.Protocol.KDF import PBKDF2
from Crypto.Hash import HMAC
from Crypto.Hash import SHA256
import argparse
import binascii

# Standard PBKDF2
def hmac_sha256(secret, salt):
    m = HMAC.new(secret, None, SHA256)
    m.update(salt)
    return m.digest()

def sxor (s1,s2):    
    # convert strings to a list of character pair tuples
    # go through each tuple, converting them to ASCII code (ord)
    # perform exclusive or on the ASCII code
    # then convert the result back to ASCII (chr)
    # merge the resulting array of characters as a string
    return ''.join(chr(ord(a) ^ ord(b)) for a,b in zip(s1,s2))

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--count", help="iteration count", type=int, default=65536)
parser.add_argument("-d", "--dkLen", help="derived key length", type=int, default=32)
parser.add_argument("-k", "--key", help="key hexlified", type=str)
parser.add_argument("-s", "--salt" , help="salt hexlified", type=str)
parser.add_argument("-b", "--base", help="base value hexlified", type=str)
args = parser.parse_args()

key = binascii.unhexlify(args.key)
salt = binascii.unhexlify(args.salt)
base = binascii.unhexlify(args.base)
out = PBKDF2(password=key, salt=salt, dkLen=args.dkLen, count=args.count, prf=hmac_sha256)
print binascii.hexlify(out)
print binascii.hexlify(sxor(base,out))

