# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg

DESCRIPTION="A high-performance, multiplayer code editor"
HOMEPAGE="https://zed.dev https://github.com/zed-industries/zed"
SRC_URI="
	amd64? ( https://github.com/zed-industries/zed/releases/download/v${PV}-pre/${PN%-bin}-linux-x86_64.tar.gz -> ${P}-pre-amd64.tar.gz )
	arm64? ( https://github.com/zed-industries/zed/releases/download/v${PV}-pre/${PN%-bin}-linux-aarch64.tar.gz -> ${P}-pre-arm64.tar.gz )
"
S="${WORKDIR}/${PN%-bin}-preview.app"

LICENSE="
	GPL-3+
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD-2
	BSD
	CC0-1.0
	ISC
	LGPL-3
	MIT
	MPL-2.0
	UoI-NCSA
	openssl
	Unicode-3.0
	ZLIB
"
SLOT="preview"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="mirror strip bindist"

RDEPEND="!app-editors/zed"

QA_PREBUILT="*"

src_install() {
	if use amd64 || use arm64; then
		cd "${WORKDIR}/${PN%-bin}-preview.app" || die
	else
		die "Zed only supports amd64 and arm64"
	fi

	if [ -f "bin/zed" ]; then
		BIN="zed"
	else
		# support for versions before 0.139.x
		BIN="cli"
	fi

	# Install
	pax-mark m bin/${BIN}
	pax-mark m libexec/zed-editor

	insinto "/opt/${PN}-preview"
	doins -r bin lib libexec || die
	fperms +x "/opt/${PN}-preview/bin/${BIN}" "/opt/${PN}-preview/libexec/zed-editor"

	dosym -r "/opt/${PN}-preview/bin/${BIN}" "usr/bin/zed-preview"
	dosym -r "/opt/${PN}-preview/libexec/zed-editor" "usr/libexec/zed-editor-preview"

	dodoc licenses.md

	sed "s|^TryExec=zed|TryExec=zed-preview|g;s|^Icon=zed|Icon=zed-preview|g;s|^Exec=zed|Exec=env ZED_UPDATE_EXPLANATION=\"Please use Portage to update Zed.\" zed-preview|g" \
		"${S}/share/applications/${PN%-bin}-preview.desktop" \
		> "${T}/dev.zed.Zed-Preview.desktop" || die

	newicon -s 512 "share/icons/hicolor/512x512/apps/zed.png" zed-preview.png
	newicon -s 1024 "share/icons/hicolor/1024x1024/apps/zed.png" zed-preview.png
	domenu "${T}/dev.zed.Zed-Preview.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Note about updating:"
	elog "Prebuilt Zed binaries come with auto-update enabled."
	elog "The ebuild makes effort to disable them by setting"
	elog "ZED_UPDATE_EXPLANATION in the .desktop file."
	elog
	elog "It is still recommended to disabled them and let portage"
	elog "handle it."
	elog
	elog "Set"
	elog "    \"auto_update\": false"
	elog "in ~/.config/zed/settings.json"
}
