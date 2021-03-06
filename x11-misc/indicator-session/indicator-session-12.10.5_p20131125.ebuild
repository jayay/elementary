# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils cmake-utils

DESCRIPTION="Session indicator"
HOMEPAGE="https://launchpad.net/indicator-session"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/indicator-session_12.10.5%2B14.04.20131125.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls static-libs"

RDEPEND="
	>=dev-libs/glib-2.38:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/indicator-session-12.10.5+14.04.20131125"

src_prepare() {
	epatch "${FILESDIR}/${P}-no-icon-cache-update.patch"
	epatch "${FILESDIR}/${P}-gsettings-path.patch"
	epatch "${FILESDIR}/${P}-gsettings-compile.patch"
	epatch "${FILESDIR}/${P}-drop-upstart.patch"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Denable_tests=OFF
		-Denable_lcov=OFF
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

