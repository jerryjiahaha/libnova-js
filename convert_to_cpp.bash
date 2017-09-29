#!/usr/bin/bash

TARDIR=libnova-cpp

cp -r -T libnova ${TARDIR}

_match=$(grep AC_PROG_CXX ${TARDIR}/configure.ac)
if [[ "x$_match" == "x" ]]; then
	sed -i '/AC_PROG_C/a AC_PROG_CXX' ${TARDIR}/configure.ac
fi

DIRS="src/elp src lntest examples"
for dir in ${DIRS}; do
	echo "${TARDIR}/$dir"
	sed -i -E 's/\.c( |$|\t)/.cpp /g' ${TARDIR}/${dir}/Makefile.am

	_match2=$(grep AM_CXXFLAGS ${TARDIR}/${dir}/Makefile.am)
	# TODO consider about delete match line first
	if [[ "x$_match2" == "x" ]]; then
		sed -i '/AM_CFLAGS/a AM_CXXFLAGS=$(AM_CFLAGS)' ${TARDIR}/${dir}/Makefile.am
	fi

	for files in `find ${TARDIR}/${dir} -name "*.c" `; do
		mv ${files} "${files%c}cpp"
	done
done

_typo=$(grep earth.h ${TARDIR}/src/parallax.cpp)
echo $_typo

if [[ "x$_typo" == "x" ]]; then
        sed -i '/#include <libnova\/sidereal_time.h>/a #include <libnova\/earth.h>' ${TARDIR}/src/parallax.cpp;
fi

