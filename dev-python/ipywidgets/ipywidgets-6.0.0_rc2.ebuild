# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 versionator

MY_PV="$(replace_version_separator 3 .)"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="http://ipython.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/traitlets-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.2.2[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-2.0.0_rc1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
	"

PATCHES=(
	"${FILESDIR}"/get_interact_value_output.patch
	"${FILESDIR}"/output_exception.patch
	"${FILESDIR}"/widget_repr.patch
	)

S="${WORKDIR}"/${MY_P}

python_test() {
	nosetests --with-coverage --cover-package=ipywidgets ipywidgets || die
}
