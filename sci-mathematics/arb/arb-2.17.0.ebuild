# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C library for arbitrary-precision interval arithmetic"
HOMEPAGE="https://fredrikj.net/arb/"
SRC_URI="https://github.com/fredrik-johansson/arb/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	>=sci-mathematics/flint-2.5.0:="

DEPEND="${RDEPEND}"

src_prepare(){
	# Copied from flint which has the same issues because arb is just copying flint.
	# Of course flint doesn't a line for itself and it had to be added.
	default

	# By default "lib" is found first and in case of gc 
	# it is the only one searched for.
	sed -e "s:{GMP_DIR}/lib\":{GMP_DIR}/$(get_libdir)\":g" \
		-e "s:{MPFR_DIR}/lib\":{MPFR_DIR}/$(get_libdir)\":g" \
		-e "s:{FLINT_DIR}/lib\":{FLINT_DIR}/$(get_libdir)\":g" \
		-i configure
}

src_configure() {
	# Not an autoconf configure script.
	# Note that it appears to have been cloned from the flint configure script
	# and that not all the options offered are valid.
	tc-export CC AR CXX
	./configure \
		--prefix="${EPREFIX}/usr" \
		--with-flint="${EPREFIX}/usr" \
		--with-gmp="${EPREFIX}/usr" \
		--with-mpfr="${EPREFIX}/usr" \
		$(use_enable static-libs static) \
		CFLAGS="${CPPFLAGS} ${CFLAGS}" || die
}

src_compile() {
	emake verbose
}

src_test() {
	# Have to set the library path otherwise a previous install of libarb may be loaded.
	# This is in part a consequence of setting the soname/installname I think.
	if [[ ${CHOST} == *-darwin* ]] ; then
		DYLD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	else
		LD_LIBRARY_PATH="${S}" emake AT= QUIET_CC= QUIET_CXX= QUIET_AR= check
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	use static-libs || (find "${ED}" -name '*.la' -delete || die)
	dodoc README.md
}
