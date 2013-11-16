
SCRYPT_DIR=../../node_modules/triplesec/contrib/scrypt-1.1.6

build-scrypt:
	(cd ${SCRYPT_DIR} && ./configure && make clean && make)

build-pycoin:
	(cd python && (virtualenv . && source bin/activate && pip install pycoin) )

input:
	iced gen_input.iced > input.json

.PHONY: build-scrypt build-pycoin
