# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_4 )
inherit python-single-r1 autotools


DESCRIPTION="A library for manipulating block devices. "
HOMEPAGE="https://github.com/rhinstaller/libblockdev"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rhinstaller/libblockdev.git"
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/rhinstaller/${PN}/archive/${P}-1.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}-1"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="1"
IUSE="+introspection"

DEPEND=""

RDEPEND="${DEPEND}
	>=dev-libs/glib-2.42.2:2
	>=dev-libs/nss-3.18.0
	>=dev-libs/volume_key-0.3.9
	>=dev-libs/nss-3.18
	introspection? ( dev-libs/gobject-introspection )
	sys-fs/lvm2
	sys-fs/dmraid
	>=sys-apps/kmod-19
	>=virtual/libudev-215"

src_prepare() {
	epatch_user 
	epatch ${FILESDIR}/${PN}*"-ldflags.patch"
	eautoreconf
}
src_configure() {
	local myconf=""
	if use introspection ; then
		myconf="--enable-introspection=yes"
	else
		myconf="--enable-introspection=no"
	fi
	LDFLAGS="-L${EPREFIX}/lib/" econf $myconf
}

