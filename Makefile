bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
groc       = $(bin)/groc
uglify     = $(bin)/uglifyjs
VERSION    = $(shell node -e 'console.log(require("./package.json").version)')


lib: src/*.ls
	$(lsc) -o lib -c src/*.ls

dist:
	mkdir -p dist

dist/control.monads.umd.js: compile dist
	$(browserify) lib/index.js --standalone Monads > $@

dist/control.monads.umd.min.js: dist/control.monads.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/control.monads.umd.js

minify: dist/control.monads.umd.min.js

compile: lib

documentation:
	$(groc) --index "README.md"                                              \
	        --out "docs/literate"                                            \
	        src/*.ls test/*.ls test/specs/**.ls README.md

clean:
	rm -rf dist build lib

test:
	$(lsc) test/tap.ls

package: compile documentation bundle minify
	mkdir -p dist/control.monads-$(VERSION)
	cp -r docs/literate dist/control.monads-$(VERSION)/docs
	cp -r lib dist/control.monads-$(VERSION)
	cp dist/*.js dist/control.monads-$(VERSION)
	cp package.json dist/control.monads-$(VERSION)
	cp README.md dist/control.monads-$(VERSION)
	cp LICENCE dist/control.monads-$(VERSION)
	cd dist && tar -czf control.monads-$(VERSION).tar.gz control.monads-$(VERSION)

publish: clean
	npm install
	npm publish

bump:
	node tools/bump-version.js $$VERSION_BUMP

bump-feature:
	VERSION_BUMP=FEATURE $(MAKE) bump

bump-major:
	VERSION_BUMP=MAJOR $(MAKE) bump


.PHONY: test
