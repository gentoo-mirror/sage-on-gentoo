# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ntl/ntl-9.0.2.ebuild,v 1.1 2015/04/02 12:29:55 tomka Exp $

EAPI=5
inherit toolchain-funcs eutils multilib flag-o-matic

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc static-libs test"

RDEPEND="dev-libs/gmp:=
	>=dev-libs/gf2x-0.9"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"

src_prepare() {
	# fix parallel make
	sed -i -e "s/make/make ${MAKEOPTS}/g" WizardAux || die
	cd ..
	# sanitize the makefile and allow the building of shared library
	epatch "${FILESDIR}"/${PN}-9.2.0-sanitize-makefile.patch
	# fix typo
	epatch "${FILESDIR}"/${PN}-9.2.0-sp_arith.patch
	# sage call back framework
	epatch "${FILESDIR}"/${PN}-9.2.0-sage-callback.patch
	# enable compatibility with singular
	epatch "${FILESDIR}"/${PN}-9.2.0-singular.patch
	replace-flags -O[3-9] -O2
}

src_configure() {
	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		NTL_GMP_LIP=on NTL_GF2X_LIB=on NTL_LEGACY_SP_MULMOD=on \
		|| die "DoConfig failed"
}

src_compile() {
	# split the targets to allow parallel make to run properly
	emake setup1 setup2 || die "emake setup failed"
	emake setup3 || die "emake setup failed"
	sh Wizard on || die "Tuning wizard failed"
	if use static-libs; then
		emake ntl.a  || die "emake static failed"
	fi
	local trg=so
	[[ ${CHOST} == *-darwin* ]] && trg=dylib
	emake shared${trg} || die "emake shared failed"
}

src_install() {
	if use static-libs; then
		newlib.a ntl.a libntl.a || die "installation of static library failed"
	fi
	dolib.so lib*$(get_libname) || die "installation of shared library failed"

	cd ..
	insinto /usr/include
	doins -r include/NTL || die "installation of the headers failed"

	dodoc README
	if use doc ; then
		dodoc doc/*.txt || die
		dohtml doc/* || die
	fi
}

src_test(){
	# the current ebuild need static library to run tests
	emake ntl.a  || die "emake static failed"

	default
}
