# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="mirror://sagemath/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
		econf \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	if ! use static-libs; then
		find "${ED}" -name "*.la" -delete || die
	fi
}
