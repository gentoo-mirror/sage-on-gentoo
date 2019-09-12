# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Data sets for pari"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"

for p in elldata galdata galpol seadata nftables; do
	SRC_URI="${SRC_URI} http://pari.math.u-bordeaux.fr/pub/pari/packages/${p}.tgz -> ${p}-${PV}.tgz"
done
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="sci-mathematics/pari"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/pari
	doins -r data/* nftables
}
