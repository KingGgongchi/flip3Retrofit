#!/bin/bash

export ARCH=arm64
export PRODUCT_NAME=b2q
export BASE_ROOT=$(pwd)
mkdir out

BUILD_CROSS_COMPILE=$(pwd)/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$(pwd)/toolchain/Snapdragon-LLVM-10.0.9/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV=""

make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/shadow_b2q_defconfig
make -j64 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 
rm -rf $BASE_ROOT/build_output/split_img/boot.img-kernel
cp $BASE_ROOT/out/arch/arm64/boot/Image.gz $BASE_ROOT/build_output/split_img/boot.img-kernel
cd build_output
./repackimg.sh
rm -rf boot.img
mv image-new.img boot.img
rm -rf new_boot.tar
tar -cvf new_boot.tar boot.img vendor_boot.img
cd $BASE_ROOT
