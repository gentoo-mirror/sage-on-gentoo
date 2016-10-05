# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV=$(replace_version_separator 1 'r' $(delete_version_separator 2 ) )
DESCRIPTION="A GAP Interface to the Atlas of Group Representations"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
SRC_URI="http://www.gap-system.org/pub/gap/gap4/tar.bz2/packages/${PN}${MY_PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap"
RDEPEND="${DEPEND}
	net-misc/wget"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5_p0-local.patch
	)

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/"${PN}"
	doins -r bibl datagens dataword doc gap tst etc
	doins *.g

	dodoc README
}
