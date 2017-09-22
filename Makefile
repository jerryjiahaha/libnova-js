.PHONY: all compile autogen patch link

CFLAGS ?= -O2

match=$(shell grep earth.h libnova/src/parallax.c)

all: autogen compile link

link:
	emcc $(CFLAGS) libnova/src/*.o libnova/src/elp/*.o -s EXPORTED_FUNCTIONS='["_ln_get_julian_from_sys"]' -o libnova.js

compile: patch
	cd libnova && emconfigure ./configure CFLAGS=$(CFLAGS)
	cd libnova && CFLAGS=$(CFLAGS) emmake $(MAKE)

autogen:
	cd libnova && emconfigure ./autogen.sh

patch:
	@echo match is "$(match)"
	if [  "x${match}" == "x" ]; then \
		echo "patch file"; \
		sed -i '/#include <libnova\/sidereal_time.h>/i #include <libnova\/earth.h>' libnova/src/parallax.c; \
	else \
		echo "already patched"; \
	fi
