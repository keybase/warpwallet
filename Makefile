ICED=node_modules/.bin/iced
BROWSERIFY=node_modules/.bin/browserify
WD=`pwd`

test: test-server test-browser

test-server:
	$(ICED) test/run.iced

test/browser/test.js: test/browser/main.iced
	$(BROWSERIFY) -t icsify $< > $@

test-browser: test/browser/test.js
	@echo "Please visit in your favorite browser --> file://$(WD)/test/browser/index.html"

clean: 
	rm lib/lib.js test/browser/test.js

.PHONY: test test-server test-browser clean