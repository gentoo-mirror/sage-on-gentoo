# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Meta Package for GAP Documentation"
HOMEPAGE="http://www.gap-system.org/Packages/gapdoc.html"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}
	virtual/texi2dvi"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"

S="${WORKDIR}/gap-${SLOT}/pkg/${P}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r 3k+1 doc example lib styles
	doins *.g *.dtd
}
