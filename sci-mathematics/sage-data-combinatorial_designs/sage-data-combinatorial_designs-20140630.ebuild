# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PN="combinatorial_designs"
MY_P="${MY_PN}-$(replace_version_separator 1 '.')"

DESCRIPTION="Data for Combinatorial Designs"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto /usr/share/sage/combinatorial_designs
	doins *
}
