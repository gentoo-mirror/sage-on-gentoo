# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
GIT_PRS=(
	38549
	38619
	38957
)

inherit distutils-r1 sage-git-patch

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
else
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
	SRC_URI="$(pypi_sdist_url) $(get_pr_uri)"
fi

DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"

RESTRICT="mirror test"

RDEPEND="
	>=dev-python/sphinx-7.2.0[${PYTHON_USEDEP}]
	dev-python/jupyter-sphinx[${PYTHON_USEDEP}]
"
PDEPEND="~sci-mathematics/sagemath-standard-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	sage-git-patch_patch
}
