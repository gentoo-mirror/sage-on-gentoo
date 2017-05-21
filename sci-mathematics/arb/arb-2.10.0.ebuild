# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Arb is a C library for arbitrary-precision floating-point ball arithmetic."
HOMEPAGE="http://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2.1"
KEYWORDS="~amd64  ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="static-libs"

RDEPEND=">=sci-mathematics/flint-2.5.0:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.8.1-pie.patch
	"${FILESDIR}"/PR-187.patch
	)

src_configure() {
	# Not an autoconf configure script.
	# Note that it appears to have been cloned from the flint configure script
	# and that not all the options offered are valid.
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-flint="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(use_enable static-libs static) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		|| die
}

src_compile() {
	emake verbose
}

src_test() {
	# Have to set the library path otherwise a previous install of libarb may be loaded.
	# This is in part a consequence of setting the soname/installnae I think.
	if [[ ${CHOST} == *-darwin* ]] ; then
		DYLD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	else
		LD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
