# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GAP Small Groups Library"
HOMEPAGE="http://www.gap-system.org/Packages/smallgrp.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

DOCS="README.md"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap id* small*
	doins *.g
}
