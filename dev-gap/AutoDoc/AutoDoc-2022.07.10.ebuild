# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Generate documentation from GAP source code"
HOMEPAGE="https://www.gap-system.org/Packages/autodoc.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~sci-mathematics/gap-4.12.0
	>=dev-gap/GAPDoc-1.6.6"

DOCS="CHANGES README.md TODO LICENSE"

GAP_PKG_OBJS="doc gap"

src_prepare() {
	default

	rm -f makefile
}

src_install() {
	default

	gap-pkg_src_install
}
