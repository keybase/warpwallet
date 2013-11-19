ICED=node_modules/.bin/iced
BROWSERIFY=node_modules/.bin/browserify
WD=`pwd`

default: relnotes build
	
relnotes: web/release.txt

build:
	icake build


test: test-server test-browser

test-server:
	$(ICED) test/run.iced

test/browser/test.js: test/browser/main.iced
	$(BROWSERIFY) -t icsify $< > $@

test-browser: test/browser/test.js
	@echo "Please visit in your favorite browser --> file://$(WD)/test/browser/index.html"

clean: 
	rm lib/lib.js test/browser/test.js

web/release.txt: release.txt.in
	gpg --clearsign -u code@keybase.io < $< > $@

.PHONY: test test-server test-browser clean build