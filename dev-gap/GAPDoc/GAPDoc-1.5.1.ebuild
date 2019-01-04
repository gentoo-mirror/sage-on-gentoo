# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Meta Package for GAP Documentation"
HOMEPAGE="http://www.gap-system.org/Packages/gapdoc.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.8.3-r1:0
	!<=sci-mathematics/gap-4.8.3
	virtual/texi2dvi"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${P}"
	doins -r 3k+1 doc example lib mathml styles
	doins *.g *.dtd

	dodoc CHANGES README
}
