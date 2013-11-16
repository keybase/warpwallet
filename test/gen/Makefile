
SCRYPT_DIR=../../node_modules/triplesec/contrib/scrypt-1.1.6
SCRYPT=${SCRYPT_DIR}/scrypt
BU=python/bin/bu

build-scrypt:
	(cd ${SCRYPT_DIR} && ./configure && make clean && make)

build-pycoin:
	mkdir -p python
	(cd python && (virtualenv . && source bin/activate && pip install pycoin) )

input:
	iced gen_input.iced > input.json

spec:
	iced gen_spec.iced ${SCRYPT} ${BU} > ../spec.json

.PHONY: build-scrypt build-pycoin
