# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=(python3_{10..11} pypy3)

inherit distutils-r1

DESCRIPTION="West, Zephyr's meta-tool"
HOMEPAGE="https://github.com/zephyrproject-rtos/west"

SRC_URI="https://github.com/zephyrproject-rtos/west/archive/refs/tags/v1.2.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="
  >=dev-python/pykwalify-1.8.0-r3[${PYTHON_USEDEP}]
"
