# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build

RM_VER="3.22"
RM_KERNEL="linux-imx-rel-5.2-rm-3.22.0.64-cc26ce6266b2"

DESCRIPTION="Linux kernel for reMarkable Paper Pro"
HOMEPAGE="https://github.com/reMarkable/linux-imx-rm"
SRC_URI="https://github.com/reMarkable/linux-imx-rm/raw/refs/heads/rmpp_${PV}_v${RM_VER}.x/${RM_KERNEL}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"

src_unpack() {
	default
	S="${WORKDIR}/${RM_KERNEL}"
}

src_configure() {
	make ferrari_defconfig
}

src_install() {
	emake INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH="${D}/lib" modules_install

	# Create fitImage in the workdir or install it
	emake mkimage -f ferrari.its fitImage

	# Install fitImage to /boot directory in destdir
	dodir /boot
	dobin fitImage /boot/
}
