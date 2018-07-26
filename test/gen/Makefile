
SHELL := /bin/bash
SCRYPT_DIR=../../node_modules/triplesec/contrib/scrypt-1.1.6
SCRYPT=${SCRYPT_DIR}/scrypt
PBKDF2=./pbkdf2.py
KU=py-venv/bin/ku
MNEMONIC=./mnemonic/mnemonic.py

build: build-scrypt build-python

build-scrypt:
	(cd ${SCRYPT_DIR} && ./configure && make clean && make)

build-python:
	mkdir -p py-venv
	(cd py-venv && (virtualenv . && source bin/activate && pip install pycoin && pip install pycrypto) )

input:
	iced gen_input.iced > input.json

spec:
	(source py-venv/bin/activate && iced gen_spec.iced ${SCRYPT} ${PBKDF2} ${KU} ${MNEMONIC} > ../spec.json)

.PHONY: build-scrypt build-python build
