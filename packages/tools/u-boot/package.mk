################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="u-boot"
PKG_DEPENDS_TARGET="toolchain"
if [ "$UBOOT_VERSION" = "imx6-cuboxi" ]; then
  PKG_COMMIT="ad02f49"
  PKG_VERSION="imx6-$PKG_COMMIT"
  PKG_SITE="http://solid-run.com/wiki/doku.php?id=products:imx6:software:development:u-boot"
  PKG_URL="https://github.com/SolidRun/u-boot-imx6/archive/$PKG_COMMIT.tar.gz"
  PKG_SOURCE_NAME="$PKG_NAME-sr-$PKG_VERSION.tar.gz"
  PKG_SOURCE_DIR="$PKG_NAME-imx6-${PKG_COMMIT}*"
  [ -n "$UBOOT_CONFIG_V2" ] && PKG_DEPENDS_TARGET="toolchain u-boot-v2"
elif [ "$UBOOT_VERSION" = "hardkernel" ]; then
  PKG_VERSION="6e4e886"
  PKG_SITE="https://github.com/hardkernel/u-boot"
  PKG_URL="https://github.com/hardkernel/u-boot/archive/$PKG_VERSION.tar.gz"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET gcc-linaro-aarch64-elf:host gcc-linaro-arm-eabi:host"
elif [ "$UBOOT_VERSION" = "sunxi" ]; then
  PKG_VERSION="2017.01"
  PKG_SITE="http://www.denx.de/wiki/U-Boot/WebHome"
  PKG_URL="ftp://ftp.denx.de/pub/u-boot/$PKG_NAME-$PKG_VERSION.tar.bz2"
else
  exit 0
fi
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
if [ "$UBOOT_VERSION" = "sunxi" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET Python:host"
fi

pre_configure_target() {
  if [ -z "$UBOOT_CONFIG" ]; then
    echo "$TARGET_PLATFORM does not define any u-boot configuration, aborting."
    echo "Please add UBOOT_CONFIG to your project options file."
    exit 1
  fi

  if [ -z "$UBOOT_CONFIGFILE" ]; then
    UBOOT_CONFIGFILE="boot.scr"
  fi

  unset LDFLAGS

# dont build in parallel because of problems
  MAKEFLAGS=-j1

# copy compiler-gcc5.h to compiler-gcc6. for fake building
#  cp include/linux/compiler-gcc5.h include/linux/compiler-gcc6.h
}

make_target() {
  # get number of targets to build
  UBOOT_TARGET_CNT=0
  for UBOOT_TARGET in $UBOOT_CONFIG; do
    UBOOT_TARGET_CNT=$((UBOOT_TARGET_CNT + 1))
  done

  for UBOOT_TARGET in $UBOOT_CONFIG; do
    if [ "$PROJECT" = "Odroid_C2" ]; then
      export PATH=$TOOLCHAIN/lib/gcc-linaro-aarch64-elf/bin/:$TOOLCHAIN/lib/gcc-linaro-arm-eabi/bin/:$PATH
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make mrproper
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make $UBOOT_TARGET
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make HOSTCC="$HOST_CC" HOSTSTRIP="true"
    else
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm mrproper
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm $UBOOT_TARGET
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm HOSTCC="$HOST_CC" HOSTSTRIP="true"
    fi

    # rename files in case of multiple targets
    if [ $UBOOT_TARGET_CNT -gt 1 ]; then
      if [ "$UBOOT_TARGET" = "mx6_cubox-i_config" ]; then
        TARGET_NAME="cuboxi"
      elif [ "$UBOOT_TARGET" = "matrix" ]; then
        TARGET_NAME="matrix"
      elif [ "$UBOOT_TARGET" = "udoo_config" ]; then
        TARGET_NAME="udoo"
      elif [ "$UBOOT_TARGET" = "orangepi_2_defconfig" ]; then
        TARGET_NAME="opi2"
      elif [ "$UBOOT_TARGET" = "orangepi_pc_defconfig" ]; then
        TARGET_NAME="opipc"
      elif [ "$UBOOT_TARGET" = "orangepi_plus_defconfig" ]; then
        TARGET_NAME="opiplus"
      elif [ "$UBOOT_TARGET" = "orangepi_one_defconfig" ]; then
        TARGET_NAME="opione"
      elif [ "$UBOOT_TARGET" = "orangepi_lite_defconfig" ]; then
        TARGET_NAME="opilite"
      elif [ "$UBOOT_TARGET" = "Sinovoip_BPI_M2_plus_defconfig" ]; then
        TARGET_NAME="bpim2p"
      elif [ "$UBOOT_TARGET" = "orangepi_plus2e_defconfig" ]; then
        TARGET_NAME="opiplus2e"
      elif [ "$UBOOT_TARGET" = "orangepi_pc_plus_defconfig" ]; then
        TARGET_NAME="opipcplus"
      elif [ "$UBOOT_TARGET" = "Sinovoip_BPI_M3_defconfig" ]; then
        TARGET_NAME="bpim3"
      elif [ "$UBOOT_TARGET" = "beelink_x2_defconfig" ]; then
        TARGET_NAME="bx2"  
      else
        TARGET_NAME="undef"
      fi
      if [ -f "$PROJECT_DIR/$PROJECT/logo/splash-$TARGET_NAME.bmp" ]; then
         LOGOIMG="$PROJECT_DIR/$PROJECT/logo/splash-$TARGET_NAME.bmp"
      elif [ -f "$PROJECT_DIR/$PROJECT/logo/splash.bmp" ]; then
         LOGOIMG="$PROJECT_DIR/$PROJECT/logo/splash.bmp"
      fi
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" mrproper
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" $UBOOT_TARGET
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH="$TARGET_ARCH" HOSTCC="$HOST_CC" HOSTSTRIP="true" LOGO_BMP="$LOGOIMG"

      [ -f u-boot.img ] && mv u-boot.img u-boot-$TARGET_NAME.img || :
      [ -f u-boot.imx ] && mv u-boot.imx u-boot-$TARGET_NAME.imx || :
      [ -f u-boot-sunxi-with-spl.bin ] && mv u-boot-sunxi-with-spl.bin uboot-sunxi-$TARGET_NAME.bin || :
      [ -f SPL ] && mv SPL SPL-$TARGET_NAME || :
    fi
     [ -f u-boot-sunxi-with-spl.bin ] && mv u-boot-sunxi-with-spl.bin uboot-sunxi-bpim3.bin || :
  done
}

makeinstall_target() {
  mkdir -p $TOOLCHAIN/bin
    if [ -f build/tools/mkimage ]; then
      cp build/tools/mkimage $TOOLCHAIN/bin
    else
      cp tools/mkimage $TOOLCHAIN/bin
    fi

  BOOT_CFG="$PROJECT_DIR/$PROJECT/bootloader/boot.cfg"
  if [ -r "$BOOT_CFG" ]; then
    cp $BOOT_CFG boot.cfg
    mkimage -A "$TARGET_ARCH" \
            -O u-boot \
            -T script \
            -C none \
            -n "$DISTRONAME Boot" \
            -d boot.cfg \
            $UBOOT_CONFIGFILE
  fi

  mkdir -p $INSTALL/usr/share/bootloader

  cp $PKG_BUILD/u-boot*.imx $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp $PKG_BUILD/u-boot*.img $INSTALL/usr/share/bootloader 2>/dev/null || :

  #NOTE: sunxi u-boot build folder contains intermediate .img files which are not needed
  if [ -f ./uboot-sunxi-opi2.bin -o -f ./uboot-sunxi-bpim3.bin ]; then
    cp ./uboot-sunxi-*.bin $INSTALL/usr/share/bootloader 2>/dev/null
  else
    cp $PKG_BUILD/u-boot*.img $INSTALL/usr/share/bootloader 2>/dev/null || :
  fi
  cp $PKG_BUILD/SPL* $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp $PKG_BUILD/$UBOOT_CONFIGFILE $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp -PR $PROJECT_DIR/$PROJECT/bootloader/uEnv*.txt $INSTALL/usr/share/bootloader 2>/dev/null || :

  case $PROJECT in
    Odroid_C2)
      cp -PRv $PKG_DIR/scripts/update-c2.sh $INSTALL/usr/share/bootloader/update.sh
      cp -PRv $PKG_BUILD/u-boot.bin $INSTALL/usr/share/bootloader/u-boot
      if [ -f $PROJECT_DIR/$PROJECT/splash/boot-logo.bmp.gz ]; then
        cp -PRv $PROJECT_DIR/$PROJECT/splash/boot-logo.bmp.gz $INSTALL/usr/share/bootloader
      elif [ -f $DISTRO_DIR/$DISTRO/splash/boot-logo.bmp.gz ]; then
        cp -PRv $DISTRO_DIR/$DISTRO/splash/boot-logo.bmp.gz $INSTALL/usr/share/bootloader
      fi
      ;;
    imx6)
      cp -PRv $PKG_DIR/scripts/update.sh $INSTALL/usr/share/bootloader
      ;;
     *)
      cp -PRv $PKG_DIR/scripts/update.sh $INSTALL/usr/share/bootloader
      ;;  
  esac
}
