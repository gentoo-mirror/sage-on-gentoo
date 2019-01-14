# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-version-${PV}"
DESCRIPTION="Quivers and Path Algebras"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/gbnp:${SLOT}"

DOCS="README CHANGES"
HTML_DOCS=htm/*

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${MY_P}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r doc examples lib
	doins *.g
}
