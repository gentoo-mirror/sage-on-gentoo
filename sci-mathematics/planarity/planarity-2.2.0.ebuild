# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="This code project provides a library for implementing graph algorithms"
HOMEPAGE="https://code.google.com/p/planarity/"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"
IUSE="static-libs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-extern.patch
	"${FILESDIR}"/${PN}-2.2.0-malloc.patch
	"${FILESDIR}"/${PN}-2.2.0-no_nauty.patch
	)
