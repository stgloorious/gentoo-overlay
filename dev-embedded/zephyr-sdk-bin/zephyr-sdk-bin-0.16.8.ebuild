# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Zephyr SDK (Toolchains, Development Tools)"
HOMEPAGE="https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html"

SRC_URI="amd64? ( https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${PV}/zephyr-sdk-${PV}_linux-x86_64.tar.xz )
		 arm64? ( https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${PV}/zephyr-sdk-${PV}_linux-aarch64.tar.xz )
		 verify-sig? ( https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${PV}/sha256.sum )"

inherit toolchain-funcs

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+verify-sig"
COMMON_TARGETS="aarch64
				arc64
				arc
				arm
				microblazeel
				mips
				nios2
				riscv64
				sparc
				x86_64
"
IUSE_TARGETS="${COMMON_TARGETS}"
use_targets=$(printf ' zephyr_targets_%s' ${IUSE_TARGETS})
IUSE+=" ${use_targets}"

KEYWORDS="~amd64 ~arm64"

RDEPENDS=">=sys-apps/dtc-1.6.0
		  >=app-emulation/qemu-7.0.0
		  >=dev-embedded/openocd-0.11.0
		  =dev-lang/python:3.8
"

QA_PREBUILT="*"
RESTRICT="strip"

copy_toolchain(){
	insopts -m0644
	insinto "${DEST}/${TARGET_ARCH}-zephyr-${TARGET_EXT}"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/share"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/picolibc"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/lib"
	insinto "${DEST}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/include"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/lib"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/sys-include"
	insopts -m0755
	insinto "${DEST}/${TARGET_ARCH}-zephyr-${TARGET_EXT}"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/libexec"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/bin"
	insinto "${DEST}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}"
	doins -r "${S}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/${TARGET_ARCH}-zephyr-${TARGET_EXT}/bin"
}

src_unpack() {
	if use verify-sig; then
	  cd ${DISTDIR}
	  shasum ${DISTDIR}/sha256.sum --check --ignore-missing || die
	fi

	cp ${DISTDIR}/*.tar.xz ${WORKDIR}/${PN}.tar.xz
	cd ${WORKDIR}
	tar xf ${WORKDIR}/${PN}.tar.xz
	mkdir -p ${S}
	mv ${WORKDIR}/zephyr-sdk-${PV}/* ${S}
}
src_install(){
	DEST="/opt/${PN}-${PV}"
	echo 
	if use zephyr_targets_aarch64; then
	  TARGET_ARCH=aarch64
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_arc64; then
	  TARGET_ARCH=arc64
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_arc; then
	  TARGET_ARCH=arc
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_arm; then
	  TARGET_ARCH=arm
	  TARGET_EXT=eabi
	  copy_toolchain
	fi
	if use zephyr_targets_microblazeel; then
	  TARGET_ARCH=microblazeel
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_mips; then
	  TARGET_ARCH=mips
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_nios2; then
	  TARGET_ARCH=nios2
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_riscv64; then
	  TARGET_ARCH=riscv64
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_sparc; then
	  TARGET_ARCH=sparc
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	if use zephyr_targets_x86_64; then
	  TARGET_ARCH=x86_64
	  TARGET_EXT=elf
	  copy_toolchain
	fi
	
	insinto "${DEST}"
	insopts -m0644
	doins ${S}/sdk_toolchains
	doins ${S}/sdk_version
	doins -r ${S}/cmake

	exeinto "${DEST}"
	doexe ${S}/setup.sh


	elog "********************************************************************************"
	elog "* In order for CMake to recognize Zephyr SDK automatically, please run          "
	elog "* ${DEST}/setup.sh -c"
	elog "* to register the SDK with the current user (HOME/.cmake).					  "
	elog "********************************************************************************"	
}
