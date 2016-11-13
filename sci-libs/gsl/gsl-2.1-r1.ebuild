# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit alternatives-2 autotools multilib-build toolchain-funcs

DESCRIPTION="GNU Scientific Library"
HOMEPAGE="http://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/19"
KEYWORDS="~amd64 ~mips ~s390 ~sh ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( >=virtual/cblas-2.0-r3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-cblas-external.patch
	)

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

src_configure() {
	gsl_configure() {
		cd "${BUILD_DIR}"
		if use cblas-external; then
			export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
			export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
		fi
		econf $(use_with cblas-external)
	}
	multilib_foreach_abi gsl_configure
}

src_compile() {
	gsl_compile() {
		cd "${BUILD_DIR}"
		default
	}
	multilib_foreach_abi gsl_compile
}

src_install() {
	gsl_install() {
		cd "${BUILD_DIR}"
		local libname=gslcblas

		cat <<-EOF > ${libname}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${libname}
		Description: ${DESCRIPTION} CBLAS implementation
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${libname}
		Libs.private: -lm
		Cflags: -I\${includedir}
		EOF
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${libname}.pc

		GSL_ALTERNATIVES+=( /usr/$(get_libdir)/pkgconfig/cblas.pc ${libname}.pc )

		default
	}
	multilib_foreach_abi gsl_install

	# Don't add gsl as a cblas alternative if using cblas-external
	use cblas-external || alternatives_for cblas gsl 0 \
		${GSL_ALTERNATIVES[@]} \
		/usr/include/cblas.h gsl/gsl_cblas.h
}

src_test() {
	gsl_test() {
		cd "${BUILD_DIR}"
		default
	}
	multilib_foreach_abi gsl_test
}
