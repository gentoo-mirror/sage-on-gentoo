# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="https://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="sci-libs/suitesparseconfig"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	econf \
		$(use_with doc) \
		$(use_enable static-libs static)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
