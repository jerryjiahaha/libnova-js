.PHONY: patch

match=$(shell grep earth.h libnova/src/parallax.c)

patch:
	@echo match is "$(match)"
	if [  "x${match}" == "x" ]; then \
		echo "patch file"; \
		sed -i '/#include <libnova\/sidereal_time.h>/i #include <libnova\/earth.h>' libnova/src/parallax.c; \
	else \
		echo "already patched"; \
	fi
