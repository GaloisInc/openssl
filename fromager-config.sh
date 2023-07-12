#!/bin/bash

export LLVM_SUFFIX=-11

openssl_dir="$(cd "$(dirname "$0")" && pwd)"

target=${OPENSSL_TARGET:-linux64-riscv64}
case $target in
    linux-x86_64)
        export PICOLIBC_HOME="$openssl_dir/../picolibc/build-x86/image/picolibc/x86_64-unknown-fromager"
        TARGET_CFLAGS=
        ;;
    linux64-riscv64)
        export PICOLIBC_HOME="$openssl_dir/../picolibc/build/image/picolibc/riscv64-unknown-fromager"
        TARGET_CFLAGS="--target=riscv64-unknown-elf -march=rv64im"
        ;;
    *)
        echo "unknown target $target" 1>&2
        exit 1
        ;;
esac

export CLANG_DIR="$(clang${LLVM_SUFFIX} -print-resource-dir)"
export CC=clang${LLVM_SUFFIX}

$openssl_dir/Configure $target \
    no-asm no-dso no-threads no-shared no-zlib \
    no-sock no-ui-console no-afalgeng \
    --with-rand-seed=none \
    no-camellia no-des no-seed \
    no-bf no-cast no-dsa no-dh no-idea \
    no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 \
    no-ssl3 \
    $TARGET_CFLAGS \
    -fembed-bitcode -flto \
    -mprefer-vector-width=1 \
    -nostdinc \
    "-isystem $CLANG_DIR/include" \
    "-isystem $PICOLIBC_HOME/include" \
    -DCHEESECLOTH \
    -DPURIFY \
    -DDEVRANDOM_EGD=0 \
    -DOPENSSL_DEV_NO_ATOMICS=1 \
    -g


    #no-bf no-camellia no-cast no-des no-dsa no-idea no-md2 no-md4 no-mdc2 \
    #no-rc2 no-rc4 no-rc5 no-ripemd no-seed no-sha512 \
    #no-ssl2 no-ssl3 \
    #no-gost no-srp no-rsax no-ec no-krb5 no-zlib no-sctp \
