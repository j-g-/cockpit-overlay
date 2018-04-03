# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=(python{2_7,3_3})
inherit user eutils python-any-r1

DESCRIPTION="Performance Co-Pilot, system performance and analysis framework"
HOMEPAGE="http://pcp.io"
SRC_URI="https://github.com/performancecopilot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+ssp +pie threads infiniband discovery systemd X qt4 python papi perfevent manager webapi doc"

DEPEND=" systemd? ( sys-apps/systemd )
X? ( x11-libs/libXt )
qt4? ( dev-qt/qtcore:4 )
python? ( ${PYTHON_DEPS} )
perfevent? ( dev-libs/libpfm )
papi? ( dev-libs/papi )
discovery? ( net-dns/avahi[dbus] )
webapi? ( net-libs/libmicrohttpd[messages] )"
#doc? ( app-doc/xmlto )

RDEPEND="${DEPEND}"

pkg_setup(){
	if [ -z "$(egetent group pcp 2>/dev/null)" ]; then
		enewgroup pcp
		einfo
		einfo "The group 'pcp' has been created. Any users you add to this"
		einfo "group have access to files created by the daemons."
		einfo
	fi

	if [ -z "$(egetent passwd pcp 2>/dev/null)" ]; then
		enewuser pcp -1    -1 /var/lib/pcp pcp
		einfo
		einfo "The user 'pcp' has been created."
		einfo
	fi
	use python && python-any-r1_pkg_setup
}

src_configure() {
	# Setting xmlto as default documentation generator
	use doc && export BOOK_TOOLCHAIN="xmlto"

	# Configuration flags
	local myconf="\
		--localstatedir=${ROOT}/var \
		$(use_enable ssp) \
		$(use_enable pie) \
		$(use_with threads) \
		$(use_with infiniband) \
		$(use_with discovery) \
		$(use_with systemd) \
		$(use_with papi) \
		$(use_with perfevent) \
		$(use_with manager) \
		$(use_with webapi) "
	use python && myconf+=" --with-python "
	use doc    && myconf+=" --with-books"
	use qt4    && myconf+=" --with-qt"
	use X      && myconf+=" --with-x"
	econf $myconf
}

src_compile(){
	export MAKEOPTS="-j1"
	emake
}

src_install() {
	DIST_ROOT=${D} emake -j1 install
	dodoc CHANGELOG README.md
}
