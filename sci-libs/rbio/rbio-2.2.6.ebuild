# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sparse matrices Rutherford/Boeing format tools"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=sci-libs/suitesparseconfig-5.4.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable static-libs static)
}
