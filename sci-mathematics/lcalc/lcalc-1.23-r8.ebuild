# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A program for calculating with L-functions"
HOMEPAGE="http://oto.math.uwaterloo.ca/~mrubinst/L_function_public/L.html"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="pari"

# TODO: depend on pari[gmp] ?
DEPEND="pari? ( sci-mathematics/pari:= )"
RDEPEND="${DEPEND}"

# testing does not work because archive missed test program!
RESTRICT="mirror test"

src_prepare() {
	# patch for proper installation routine, flag respect and crufty linking flag removal.
	eapply "${FILESDIR}"/${P}-makefile.patch

	# gcc 4.6+ fix
	eapply "${FILESDIR}"/${PN}-1.23-gcc-4.6-fix.patch
	# fix error that pops up with GCC >= 4.9
	eapply "${FILESDIR}"/${PN}-1.23-fix-default-argument.patch
	# patch to support GCC 5.1+
	eapply "${FILESDIR}"/${PN}-1.23_default_parameters_2.patch

	# macos patching
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i \
			-e "s:.so:.dylib:g" \
			-e "s:-dynamiclib:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libLfunction.dylib:g" \
			src/Makefile || die "sed for macos failed"
	fi

	if use pari ; then
		# macro for pari
		export PARI_DEFINE=-DINCLUDE_PARI

		# patch pari's location in a prefix safe way.
		sed -i \
			-e "s:LOCATION_PARI_H = /usr/include/pari:LOCATION_PARI_H = ${EPREFIX}/usr/include/pari:" \
			-e "s:LOCATION_PARI_LIBRARY = /usr/lib:LOCATION_PARI_LIBRARY = ${EPREFIX}/usr/$(get_libdir):" \
			src/Makefile || die "sed for pari location failed"

		if has_version "=sci-mathematics/pari-2.5*" ; then
			# This is the patch included in r5 and r6, r4 has a different patch
			eapply "${FILESDIR}"/${PN}-1.23-init_stack.patch
			# patch for pari-2.4+ this pari-2.3 safe.
			sed -i "s:lgeti:(long)cgeti:g" src/Lcommandline_elliptic.cc \
				|| die "sed for lgeti failed"
		elif has_version "=sci-mathematics/pari-2.7*" ; then
			eapply "${FILESDIR}"/${PN}-1.23-init_stack.patch
			# compatibility with pari 2.7
			eapply "${FILESDIR}"/pari-2.7.patch
		elif has_version ">=sci-mathematics/pari-2.8_pre20150225" ; then
			# compatibility with pari 2.8+
			eapply "${FILESDIR}"/pari-2.8.patch
		fi
	fi

	default
}

src_compile() {
	emake -C src CC=$(tc-getCXX)
}

src_install() {
	emake -C src DESTDIR="${ED}"/usr LIB_DIR=$(get_libdir) install

	dodoc README
}
