# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GAP Primitive Permutation Groups Library"
HOMEPAGE="http://www.gap-system.org/Packages/primgrp.html"
GAP_VERSION="4.10.1"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}"

DOCS="README.md"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc lib
	doins *.g
}
