# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A package for semigroups and monoids"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/Semigroups/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( >=sci-mathematics/gap-core-4.11.1 >=sci-mathematics/gap-4.11.1 )
	>=sci-libs/libsemigroups-1.3.6"
RDEPEND="${DEPEND}
	>=dev-gap/orb-4.8.2
	>=dev-gap/io-4.5.4
	>=dev-gap/images-1.3.0
	>=dev-gap/datastructures-0.2.5
	>=dev-gap/digraphs-1.2.0
	>=dev-gap/genss-1.6.5"

DOCS="CHANGELOG.md README.md CONTRIBUTING.md"

src_configure(){
	# We need to know GAParch to install the dynamic object in the expected location
	# "doins -r bin" would install it with wrong permissions
	source "${EPREFIX}"/usr/share/gap/sysinfo.gap
	# Unsetting ABI as gap use the variable internally.
	econf \
		--with-external-libsemigroups \
		--libdir="${EPREFIX}/usr/share/gap/pkg/${P}/bin/${GAParch}" \
		--with-gaproot="${EPREFIX}/usr/share/gap" \
		LIBS="-lgap" \
		ABI=""
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r data doc gap
	doins *.g
}
