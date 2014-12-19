#! /bin/bash

set -e
set -u
set -x

CC="clang++"
CCFLAGS="-std=c++11 -O2 -g -Wall -Werror"
I386_TARGET="--target=i386-unknown-linux"
X8664_TARGET="--target=x86_64-unknown-linux"

$CC bench.cc sete.i386.S -o sete.i386 $CCFLAGS $I386_TARGET
$CC bench.cc sete.i386-fast.S -o sete.i386-fast $CCFLAGS $I386_TARGET
$CC bench.cc sete.x86-64.S -o sete.x86-64 $CCFLAGS $X8664_TARGET
$CC bench.cc sete.x86-64-fast.S -o sete.x86-64-fast $CCFLAGS $X8664_TARGET

$CC bench.cc lahf-sahf.i386.S -o lahf-sahf.i386 $CCFLAGS $I386_TARGET
$CC bench.cc lahf-sahf.i386-fast.S -o lahf-sahf.i386-fast $CCFLAGS $I386_TARGET
$CC bench.cc lahf-sahf.x86-64.S -o lahf-sahf.x86-64 $CCFLAGS $X8664_TARGET
$CC bench.cc lahf-sahf.x86-64-fast.S -o lahf-sahf.x86-64-fast $CCFLAGS $X8664_TARGET

$CC bench.cc pushf-popf.i386.S -o pushf-popf.i386 $CCFLAGS $I386_TARGET
$CC bench.cc pushf-popf.i386-fast.S -o pushf-popf.i386-fast $CCFLAGS $I386_TARGET
$CC bench.cc pushf-popf.x86-64.S -o pushf-popf.x86-64 $CCFLAGS $X8664_TARGET
$CC bench.cc pushf-popf.x86-64-fast.S -o pushf-popf.x86-64-fast $CCFLAGS $X8664_TARGET

set +x

echo "+---------------------+--------------+----------------------------------+"

./sete.i386
./sete.i386-fast
./sete.x86-64
./sete.x86-64-fast

./lahf-sahf.i386
./lahf-sahf.i386-fast
./lahf-sahf.x86-64
./lahf-sahf.x86-64-fast

./pushf-popf.i386
./pushf-popf.i386-fast
./pushf-popf.x86-64
./pushf-popf.x86-64-fast

echo "+---------------------+--------------+----------------------------------+"
