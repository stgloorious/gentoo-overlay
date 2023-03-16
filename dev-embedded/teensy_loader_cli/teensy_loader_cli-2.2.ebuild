# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line Teensy loader"
HOMEPAGE="https://www.pjrc.com/teensy/loader_cli.html"

SRC_URI="https://github.com/PaulStoffregen/teensy_loader_cli/archive/refs/tags/2.2.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/libusb-1.0.26"

PATCHES=(
	"${FILESDIR}"/${P}-disable-strip.patch
	)

src_install(){
  mkdir -p ${D}/usr/bin
  mv teensy_loader_cli ${D}/usr/bin
}
