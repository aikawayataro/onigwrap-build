#!/bin/bash

set -e

mkdir buildprefix

pushd oniguruma

autoreconf -i
./configure --enable-shared=no --with-pic=yes --host="$_HOST" --prefix="$(realpath ../buildprefix)" || (cat config.log; exit 1)
make
make install

popd

rm -f TextMateSharp/onigwrap/src/oniguruma.h
$_HOST-gcc -shared -fPIC TextMateSharp/onigwrap/src/onigwrap.c -O2 -s -I ./buildprefix/include -L ./buildprefix/lib -lonig -o "$_LIBNAME"
