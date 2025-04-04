# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
	SAGE_PKG="sage-setup"
else
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"

RESTRICT="mirror test"

DEPEND="
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.6-verbosity.patch
)
