
SCRYPT_DIR=../../node_modules/triplesec/contrib/scrypt-1.1.6
SCRYPT=${SCRYPT_DIR}/scrypt
BU=python/bin/bu

build-scrypt:
	(cd ${SCRYPT_DIR} && ./configure && make clean && make)

build-python:
	mkdir -p py-venv
	(cd py-venv && (virtualenv . && source bin/activate && pip install pycoin && pip install pycrypto) )

input:
	iced gen_input.iced > input.json

spec:
	iced gen_spec.iced ${SCRYPT} ${BU} > ../spec.json

.PHONY: build-scrypt build-python
