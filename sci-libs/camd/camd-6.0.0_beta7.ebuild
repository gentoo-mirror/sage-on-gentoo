# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PV=$(ver_rs 3 '-')
TOPNAME="SuiteSparse-${MY_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${MY_PV}.tar.gz -> ${TOPNAME}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~sci-libs/suitesparseconfig-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${TOPNAME}/${PN^^}"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./camd_demo > camd_demo.out
	diff "${S}"/Demo/camd_demo.out camd_demo.out || die "failed testing"
	./camd_l_demo > camd_l_demo.out
	diff "${S}"/Demo/camd_l_demo.out camd_l_demo.out || die "failed testing"
	./camd_demo2 > camd_demo2.out
	diff "${S}"/Demo/camd_demo2.out camd_demo2.out || die "failed testing"
	./camd_simple > camd_simple.out
	diff "${S}"/Demo/camd_simple.out camd_simple.out || die "failed testing"
}
