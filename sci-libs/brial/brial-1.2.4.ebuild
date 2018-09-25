# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="BriAL, a successor to PolyBoRI: Polynomials over Boolean Rings"
HOMEPAGE="https://github.com/BRiAl/BRiAl"

SRC_URI="https://github.com/BRiAl/BRiAl/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc static-libs"

RESTRICT="mirror"

CDEPEND=">=dev-libs/boost-1.58.0
	>=sci-libs/m4ri-20140914
	!sci-mathematics/brial"

DEPEND="virtual/pkgconfig
	${CDEPEND}"
RDEPEND="${CDEPEND}"

pkg_setup(){
	tc-export PKG_CONFIG
}

src_configure(){
	econf \
		--with-boost="${EPREFIX}"/usr \
		$(use_enable static-libs static)
}

src_install(){
	default

	find "${ED}" -name '*.la' -delete || die
}

src_test(){
	# race condition between linking the test program and its sources
	emake -j1 check
}
