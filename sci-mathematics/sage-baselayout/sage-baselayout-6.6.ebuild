# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils prefix python-r1 versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/sagemath/sage.git"
	EGIT_SOURCEDIR="${WORKDIR}/sage-${PV}"
	EGIT_BRANCH=develop
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
fi

DESCRIPTION="Sage baselayout files"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="${SRC_URI}
	mirror://sagemath/patches/sage-bin-patches-6.6-r1.tar.bz2
	mirror://sagemath/patches/sage-icon.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug testsuite X"

RESTRICT="mirror"

DEPEND="
	!sci-mathematics/sage-extcode"
if  [[ ${CHOST} == *-darwin* ]] ; then
	RDEPEND="${DEPEND}
		debug? ( sys-devel/gdb-apple )"
else
	RDEPEND="${DEPEND}
		debug? ( sys-devel/gdb )"
fi

S="${WORKDIR}/sage-${PV}/src/bin"
EXTSRC="${WORKDIR}/sage-${PV}/src/ext"

# TODO: scripts into /usr/libexec ?
src_prepare() {
	# ship our own version of sage-env
	cp "${FILESDIR}"/proto.sage-env-6.0 "${S}"/sage-env
	eprefixify sage-env

	# make .desktop file
	cat > "${T}"/sage-sage.desktop <<-EOF
		[Desktop Entry]
		Name=Sage Shell
		Type=Application
		Comment=Math software for algebra, geometry, number theory, cryptography and numerical computation
		Exec=sage
		TryExec=sage
		Icon=sage
		Categories=Education;Science;Math;
		Terminal=true
	EOF

	# Eliminate SAGE_ROOT, replacing with SAGE_LOCAL if necessary
	epatch "${WORKDIR}"/sage-bin-6.5-sage_root.patch

	# TODO: if USE=debug/testsuite, remove corresponding options

	# replace MAKE by MAKEOPTS in sage-num-threads.py
	sed -i "s:os.environ\[\"MAKE\"\]:os.environ\[\"MAKEOPTS\"\]:g" \
		sage-num-threads.py

	# remove developer- and unsupported options
	epatch "${WORKDIR}"/sage-exec-6.6.patch
	eprefixify sage

	# create expected folders under extcode
	mkdir -p "${EXTSRC}"/sage
}

src_install() {
	# TODO: patch sage-core and remove sage-native-execute ?

	# core scripts which are needed in every case
	python_foreach_impl python_doscript \
		sage-cleaner \
		sage-eval \
		sage-ipython \
		sage-run \
		sage-num-threads.py \
		sage-rst2txt \
		sage-rst2sws \
		sage-sws2rst
	dobin sage-maxima.lisp sage-native-execute
	dobin sage

	# install sage-env under /etc
	insinto /etc
	doins sage-env sage-banner

	if use testsuite ; then
		# DOCTESTING helper scripts
		python_foreach_impl python_doscript sage-runtests
	fi

	# COMMAND helper scripts
	python_foreach_impl python_doscript \
		sage-cython \
		sage-notebook \
		sage-run-cython
	dobin sage-python sage-version.sh

	# additonal helper scripts
	python_foreach_impl python_doscript sage-preparse sage-startuptime.py

	if use debug ; then
		# GNU DEBUGGER helper schripts
		python_foreach_impl python_doscript sage-CSI
		insinto /usr/bin
		doins sage-CSI-helper.py sage-gdb-commands

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind
	fi

	insinto /usr/share/sage
	doins ../../COPYING.txt

	if use X ; then
		doicon "${WORKDIR}"/sage.svg
		domenu "${T}"/sage-sage.desktop
	fi

	cd "${EXTSRC}"
	insinto /usr/share/sage/ext
	doins -r *
}
