ICED=node_modules/.bin/iced
BROWSERIFY=node_modules/.bin/browserify
WD=`pwd`

lib/lib.js: src/pre.js \
	src/array.map.js \
	src/biginteger.js \
	src/cryptojs.js \
	src/cryptojs.ripemd160.js \
	src/cryptojs.sha256.js \
	src/ellipticcurve.js \
	src/bitcoinjs-lib.address.js \
	src/bitcoinjs-lib.base58.js \
	src/bitcoinjs-lib.eckey.js \
	src/bitcoinjs-lib.util.js \
	src/post.js
	cat $^ > $@

default: lib/lib.js

test: test-server test-browser

test-server:
	$(ICED) test/run.iced

test/browser/test.js: test/browser/main.iced lib/lib.js
	$(BROWSERIFY) -t icsify $< > $@

test-browser: test/browser/test.js
	@echo "Please visit in your favorite browser --> file://$(WD)/test/browser/index.html"

clean: 
	rm lib/lib.js test/browser/test.js

.PHONY: test test-server test-browser clean