# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MY_PV="0.0.9pl3"
DESCRIPTION="A GP to C translator"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/pari/GP2C/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.8_pre20151001
	dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/20150326.patch
	"${FILESDIR}"/global.patch
	)

src_configure(){
	local myeconfargs=(
		--with-paricfg="${EPREFIX}/usr/share/pari/pari.cfg"
		)
	autotools-utils_src_configure
}
