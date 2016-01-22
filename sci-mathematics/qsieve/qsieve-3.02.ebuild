# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A program for factoring numbers"
HOMEPAGE="http://www.thorstenreinecke.de/qsieve/"
SRC_URI="http://www.thorstenreinecke.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc cpu_flags_x86_sse2"

RESTRICT="mirror"

CDEPEND="dev-libs/gmp:="
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.02-fix-programming-errors.patch
	)

src_configure() {
	econf \
		$(use_enable doc reference-manual) \
		$(use_enable cpu_flags_x86_sse2 SSE2)
}
