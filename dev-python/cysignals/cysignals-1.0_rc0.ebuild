# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1

MY_PV="1.0rc0"
DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"
SRC_URI="https://github.com/sagemath/cysignals/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.bz2"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/cython-0.23.4
	>=sci-mathematics/pari-2.7.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -m doctest "${S}"/src/cysignals/*.pyx
}
