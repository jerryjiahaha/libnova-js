.PHONY: all compile autogen convert link

CFLAGS ?= -O2

TARDIR=libnova-cpp

match=$(shell grep earth.h libnova/src/parallax.c)
libnova_functions=$(shell ./get_libnova_export.bash)
export_libnova ?= $(shell echo "[" `./get_libnova_export.bash |sed 's/^ln_.*/"_&",/'` "]")


all: convert autogen compile link

#	-s EXPORTED_FUNCTIONS='["_ln_get_julian_from_sys",]' \

link:
	emcc $(CFLAGS) $(TARDIR)/src/*.o $(TARDIR)/src/elp/*.o \
	-s EXPORTED_FUNCTIONS='$(export_libnova)' \
	-o libnova_impl.js

compile:
	cd $(TARDIR) && emconfigure ./configure CFLAGS=$(CFLAGS)
	cd $(TARDIR) && CFLAGS=$(CFLAGS) emmake $(MAKE)

autogen:
	cd $(TARDIR) && emconfigure ./autogen.sh

convert:
	bash ./convert_to_cpp.bash

#patch:
#	@echo match is "$(match)"
#	if [  "x${match}" == "x" ]; then \
#		echo "patch file"; \
#		sed -i '/#include <libnova\/sidereal_time.h>/i #include <libnova\/earth.h>' libnova/src/parallax.c; \
#	else \
#		echo "already patched"; \
#	fi

clean:
	$(MAKE) -C $(TARDIR) clean
