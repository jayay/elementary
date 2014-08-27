# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION=0.24

inherit fdo-mime gnome2-utils vala cmake-utils bzr

DESCRIPTION="Slim, lightweight, GCal-syncing GTK+ Calendar application"
HOMEPAGE="http://launchpad.net/maya"
EBZR_REPO_URI="lp:maya"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	dev-libs/folks
	dev-libs/glib:2
	dev-libs/libgee:0.8
	dev-libs/libical
	gnome-base/gconf:2
	>=gnome-extra/evolution-data-server-3.8
	media-libs/libchamplain[gtk]
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3.12:3
	x11-libs/granite"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	DOCS=( AUTHORS COPYING COPYRIGHT )
}

src_prepare() {
	epatch_user

	use nls || sed -i 's/add_subdirectory(po)//' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_schemas_update
}
