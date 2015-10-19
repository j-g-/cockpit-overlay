# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="Provides a daemon, tools and libraries to access and manipulate disks, storage devices and technologies"
HOMEPAGE="http://storaged-project.github.io/"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/storaged-project/storaged.git"
	KEYWORDS=""
fi

LICENSE="GPL-2+"
SLOT="2"
IUSE="+lvm +lvmcache iscsi +btrfs +zram lsm +bcache +test"


DEPEND="net-libs/libiscsi"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch_user 
	eautoreconf
}
src_configure() {
	local myconf=(
		$(use_enable lvm lvm2 )
		$(use_enable lvmcache)
		$(use_enable iscsi)
		$(use_enable btrfs)
		$(use_enable zram)
		$(use_enable lsm)
		$(use_enable bcache)
		$(use_enable test dummy)
	)
	export CFLAGS=" -std=gnu11 "
	 econf ${myconf[@]}
}
