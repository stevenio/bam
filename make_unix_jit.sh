#!/bin/sh

# build lua jit
cd external/luajit
make
cd ../..

# auto detection of compiler
if test ! $CC; then
	if gcc --version > /dev/null 2>&1; then
		CC=gcc
	elif clang --version > /dev/null 2>&1; then
		CC=clang
	fi

	if test ! $CC; then
		echo No compiler found. Specify compiler by setting the CC environment variable.
		echo Example: CC=gcc ./$0
		exit
	fi
fi

# the actual compile
echo compiling using $CC...
$CC -Wall -ansi -pedantic src/tools/txt2c.c -o src/tools/txt2c
src/tools/txt2c src/base.lua src/tools.lua src/driver_gcc.lua src/driver_clang.lua src/driver_cl.lua > src/internal_base.h
# $CC -Wall -ansi -pedantic src/*.c -o bam -Iexternal/luajit/src -Lexternal/luajit/src -lluajit -lm -lpthread -ldl -O2 -rdynamic $*
$CC -Wall -ansi -pedantic src/*.c -o bam -Iexternal/luajit/src external/luajit/src/libluajit.a -lm -lpthread -ldl -O2 -rdynamic $*
