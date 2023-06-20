#!/bin/bash

export LLVM_SUFFIX=-11
export PICOLIBC_HOME="$PWD/../picolibc/build/image/picolibc/riscv64-unknown-fromager"
export CLANG_DIR="$(clang${LLVM_SUFFIX} -print-resource-dir)"
export CC=clang${LLVM_SUFFIX}
./Configure linux64-riscv64 \
    no-asm no-dso no-threads no-shared no-zlib \
    no-sock no-ui-console no-afalgeng \
    --with-rand-seed=none \
    no-camellia no-des no-ec no-seed \
    no-bf no-cast no-dsa no-dh no-idea \
    no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 \
    no-ssl3 \
    --target=riscv64-unknown-elf -march=rv64im \
    -fembed-bitcode -flto \
    -mprefer-vector-width=1 \
    -nostdinc \
    "-isystem $CLANG_DIR/include" \
    "-isystem $PICOLIBC_HOME/include" \
    -DCHEESECLOTH \
    -DPURIFY \
    -DDEVRANDOM_EGD=0


    #no-bf no-camellia no-cast no-des no-dsa no-idea no-md2 no-md4 no-mdc2 \
    #no-rc2 no-rc4 no-rc5 no-ripemd no-seed no-sha512 \
    #no-ssl2 no-ssl3 \
    #no-gost no-srp no-rsax no-ec no-krb5 no-zlib no-sctp \
