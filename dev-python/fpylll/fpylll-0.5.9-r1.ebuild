# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="A Python (2 and 3) wrapper for fplll."
HOMEPAGE="https://github.com/fplll/fpylll"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND=">=sci-libs/fplll-5.4.4
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}"
BDEPEND=">=dev-python/cython-3.0.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/0001-Do-not-set-library-path.patch
	"${FILESDIR}"/cython-3.patch
)

distutils_enable_tests pytest

src_test() {
	PY_IGNORE_IMPORTMISMATCH=1 distutils-r1_src_test
}
