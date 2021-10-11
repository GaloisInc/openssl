#!/bin/bash

export LLVM_SUFFIX=-9
export PICOLIBC_HOME="$PWD/../picolibc/build/image/picolibc/x86_64-unknown-fromager"
export CLANG_DIR="$(clang${LLVM_SUFFIX} -print-resource-dir)"
export CC=clang${LLVM_SUFFIX}
./Configure linux-x86_64 \
    no-asm no-dso no-threads no-hw no-shared no-krb5 no-zlib \
    -fembed-bitcode -flto \
    -mprefer-vector-width=1 \
    -nostdinc \
    "-isystem $CLANG_DIR/include" \
    "-isystem $PICOLIBC_HOME/include"
