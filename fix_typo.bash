#!/bin/bash


_match=$(grep earth.h libnova/src/parallax.c)
echo $_match

if [[ "x$_match" == "x" ]]; then
	sed -i '/#include <libnova\/sidereal_time.h>/i #include <libnova\/earth.h>' libnova/src/parallax.c; 
fi
