# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Jupyter kernel for PARI/GP"
HOMEPAGE="https://github.com/jdemeyer/pari_jupyter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/ipykernel-4.0.0[${PYTHON_USEDEP}]
	>=sci-mathematics/pari-2.8_pre20160209
	>=dev-python/cython-0.25[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
