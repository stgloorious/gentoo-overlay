# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small utility to convert the system trust store to a system Java KeyStore"

inherit go-module git-r3

SRC_URI="https://github.com/stgloorious/update-java-ca-certificates/archive/refs/tags/v1.0.0.tar.gz"
SRC_URI+=" https://github.com/stgloorious/update-java-ca-certificates/releases/download/v1.0.0/update-java-ca-certificates-deps.tar.xz"

EGIT_REPO_URI="https://github.com/stgloorious/update-java-ca-certificates"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

src_unpack(){
  git-r3_src_unpack
  go-module_live_vendor
}

src_configure(){
  echo "CONFIG"
  GOROOT=${WORKDIR}
  touch config 
}
src_compile() {
  go build
}

src_install() {
  mkdir -p ${D}/usr/bin
  mv update-java-ca-certificates ${D}/usr/bin
}
