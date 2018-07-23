# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pax-utils versionator

FETCH_P="${PN}_"$(replace_version_separator  3 '-')
MY_PV=$(get_version_component_range 1-3)
DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="http://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="http://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LANGS="el en es fr pt"
IUSE="ao doc examples fltk gc static-libs"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

RDEPEND="dev-libs/gmp:=[cxx]
	sys-libs/readline:=
	fltk? ( >=x11-libs/fltk-1.1.9 )
	ao? ( media-libs/libao )
	dev-libs/mpfr:=
	sci-libs/mpfi
	sci-libs/gsl:=
	>=sci-mathematics/pari-2.7:=
	dev-libs/ntl:=
	virtual/lapack
	net-misc/curl
	gc? ( dev-libs/boehm-gc )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.2-gsl_lapack.patch
	"${FILESDIR}"/${PN}-1.4.9.69-broken_integrate_test.patch
	)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	if !(use fltk); then
		eapply "${FILESDIR}"/${PN}-1.2.2-test_with_nofltk.patch
	fi
	default
	# remove non-existant include like arch for now
	sed -e '/curlbuild/d' -i src/misc.cc

	eautoreconf
}

src_configure(){
	if use fltk; then
		append-cppflags -I$(fltk-config --includedir)
		append-lfs-flags
		append-libs $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/') || die
	fi

	econf \
		--enable-gmpxx \
		$(use_enable static-libs static) \
		$(use_enable fltk gui)  \
		$(use_enable ao) \
		$(use_enable gc)

}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if use fltk; then
		if host-is-pax; then
			pax-mark -m "${ED}"/usr/bin/x*
		fi
	else
		rm -rf \
			"${ED}"/usr/bin/x* \
			"${ED}"/usr/share/application-registry \
			"${ED}"/usr/share/applications \
			"${ED}"/usr/share/icons
	fi

	if use !doc; then
		rm -R "${ED}"/usr/share/doc/giac* "${ED}"/usr/share/giac/doc/ || die
	else
		for lang in ${LANGS}; do
			if use l10n_$lang; then
				ln "${ED}"/usr/share/giac/doc/aide_cas "${ED}"/usr/share/giac/doc/"${lang}"/aide_cas || die
			else
				rm -rf "${ED}"/usr/share/giac/doc/"${lang}"
			fi
		done
	fi

	if use !examples; then
		rm -R "${ED}"/usr/share/giac/examples || die
	fi

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
